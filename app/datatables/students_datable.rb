class AttendanceDatatable
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Attendance.where(student_id: params[:student_id],activity_id: params[:activity_id]).count,
      iTotalDisplayRecords: attendance.total_entries,
      aaData: data
    }
  end

private

  def data
    attendance.map do |atten|
      [
        ERB::Util.h(atten.activity.name),
        ERB::Util.h(atten.timeslot.time_start.strftime("%I:%M%P")),
        ERB::Util.h(atten.timeslot.time_end.strftime("%I:%M%P")),
        ERB::Util.h(atten.attended_on.strftime('%d/%m/%y'))
      ]
    end
  end

  def attendance
    @attendance ||= fetch_attendance
  end

  def fetch_attendance
    attendance = Attendance.where(student_id: params[:student_id],activity_id: params[:activity_id]).order("#{sort_column} #{sort_direction}")
    attendance = attendance.page(page).per_page(per_page)
    if params[:sSearch].present?
      attendance = Attendance.where(student_id: params[:student_id],activity_id: params[:activity_id]).order("#{sort_column} #{sort_direction}")
    end
    attendance
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end