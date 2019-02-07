class Event < ActiveRecord::Base
  has_many :event_details

  validates_uniqueness_of :name
  validates :name, uniqueness: true

  def uniq_testtime_ids
    EventDetail.where(event_id: self.id).select(:testtime_id).map(&:testtime_id).uniq
  end

  def uniq_testtimes
    Testtime.where(id: uniq_testtime_ids)
  end

  def uniq_classroom_ids
    EventDetail.where(event_id: self.id).select(:classroom_id).map(&:classroom_id).uniq
  end

  def uniq_classrooms
    Classroom.where(id: uniq_classroom_ids)
  end

  def uniq_school_ids
    Classroom.where(id: uniq_classroom_ids).select(:school_id).map(&:school_id).uniq
  end

  def uniq_schools
    School.where(id: uniq_school_ids)
  end

  def uniq_city_ids
    School.where(id: uniq_school_ids).select(:city_id).map(&:city_id).uniq
  end

  def uniq_cities
    City.where(id: uniq_city_ids)
  end

  def uniq_area_ids
    City.where(id: uniq_city_ids).select(:area_id).map(&:area_id).uniq
  end

  def uniq_areas
    Area.where(id: uniq_area_ids)
  end

  # data
  def charts_actual(testtime_id = nil)
    areas = Area.all
    global_expected = 0
    global_actual = 0
    if testtime_id
      testtime_title = Testtime.find(testtime_id).name
    else
      testtime_title = '全部'
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '區域')
    data_table.new_column('number', '到考人數')
    data_table.new_column('number', '應到人數')
    data_table.new_column('number', '到考率(%) (到考人數/應到人數)')
    areas.each_with_index do |area, index|
      if testtime_id
        total_expected = area.event_details.where(event_id: self.id, testtime_id: testtime_id).sum(:expected)
        sum_area_actual = area.event_details.where(event_id: self.id, testtime_id: testtime_id).sum(:actual)
        global_expected += total_expected
        global_actual += sum_area_actual
      else
        total_expected = area.event_details.where(event_id: self.id).sum(:expected)
        sum_area_actual = area.event_details.where(event_id: self.id).sum(:actual)
        global_expected += total_expected
        global_actual += sum_area_actual
      end
      actual_rate = ((sum_area_actual.to_f/total_expected.to_f)*100)
      data_table.add_row( [ area.name, sum_area_actual, total_expected, {v: actual_rate, f: "#{actual_rate.round(2)}%"} ] )
    end
    global_rate = ((global_actual.to_f/global_expected.to_f)*100)
    data_table.add_row( [ '全國', global_actual, global_expected, {v: global_rate, f: "#{global_rate.round(2)}%"} ] )

    column_chart_opts   = { width: '100%', height: 240, title: testtime_title, legend: { position: 'bottom' } }
    column_chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, column_chart_opts)
    table_chart_opts   = { width: '100%', title: testtime_title }
    table_chart = GoogleVisualr::Interactive::Table.new(data_table, table_chart_opts)

    {column_chart: column_chart, table_chart: table_chart}
  end

  def charts_retake(testtime_id = nil)
    areas = Area.all
    if testtime_id
      testtime_title = Testtime.find(testtime_id).name
    else
      testtime_title = '全部'
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '區域')
    data_table.new_column('number', '重測人數')
    areas.each_with_index do |area, index|
      if testtime_id
        sum_area_retake = area.event_details.where(event_id: self.id, testtime_id: testtime_id).sum(:retake)
      else
        sum_area_retake = area.event_details.where(event_id: self.id).sum(:retake)
      end
      data_table.add_row( [ area.name, sum_area_retake ] )
    end

    pie_chart_opts = { width: '100%', height: 240, title: testtime_title, legend: { position: 'bottom' } }
    pie_chart = GoogleVisualr::Interactive::PieChart.new(data_table, pie_chart_opts)
    table_chart_opts = { width: '100%', title: testtime_title }
    table_chart = GoogleVisualr::Interactive::Table.new(data_table, table_chart_opts)

    {pie_chart: pie_chart, table_chart: table_chart}
  end

  def charts_violate(testtime_id = nil)
    areas = Area.all
    if testtime_id
      testtime_title = Testtime.find(testtime_id).name
    else
      testtime_title = '全部'
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '區域')
    data_table.new_column('number', '違規人數')
    areas.each_with_index do |area, index|
      if testtime_id
        sum_area_violate = area.event_details.where(event_id: self.id, testtime_id: testtime_id).sum(:violate)
      else
        sum_area_violate = area.event_details.where(event_id: self.id).sum(:violate)
      end
      data_table.add_row( [ area.name, sum_area_violate ] )
    end

    pie_chart_opts = { width: '100%', height: 240, title: testtime_title, legend: { position: 'bottom' } }
    pie_chart = GoogleVisualr::Interactive::PieChart.new(data_table, pie_chart_opts)
    table_chart_opts = { width: '100%', title: testtime_title }
    table_chart = GoogleVisualr::Interactive::Table.new(data_table, table_chart_opts)

    {pie_chart: pie_chart, table_chart: table_chart}
  end
end
