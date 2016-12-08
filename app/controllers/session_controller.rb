class SessionController < ApplicationController
  def dashboard
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
      return
    end

    classes_taken = UserSession.instance.get_user.courses_taken.split(',')
    courses = []

    classes_taken.each do |course|
      unless course == 'MAC1105' || course == 'MAC1140'
        courses.push(Course.where(:course_code => course).first)
      end
    end

    render partial: 'dashboard', layout: '/layouts/session', locals: { active: 'dashboard', courses: courses }
  end

  def generate
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
      return
    end

    courses = Major.find(UserSession.instance.get_user.major_1).requirements.split(',')
    cs_major = []

    courses.each do |course|
      cs_major.push(Course.where(:course_code => course).first)
    end

    classes_taken = UserSession.instance.get_user.courses_taken.split(',')
    potential_classes = cs_major

    classes_taken.each do |class_t|
      potential_classes.reject! { |major_c| major_c.course_code == class_t }
    end

    rejects = []
    potential_classes.each do |p_class|
      if p_class.prerequisites != ''
        p_class.prerequisites.split(',').each do |prereq|
          unless classes_taken.include?(prereq)
            rejects.push(p_class)
          end
        end
      end
    end

    rejects.each do |rejected|
      potential_classes.reject! { |major_c| (major_c.corequisites == rejected.course_code) || (major_c == rejected) }
    end

    render partial: 'generate', layout: '/layouts/session', locals: { active: 'generate', potential: potential_classes }
  end

  def settings
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
      return
    end

    unless params[:fname].nil?
      UserSession.instance.get_user.update_attribute(:first_name, params[:fname])
      UserSession.instance.get_user.update_attribute(:last_name, params[:lname])
      UserSession.instance.get_user.update_attribute(:major_1, params[:major].to_i)
      UserSession.instance.get_user.update_attribute(:credits_taken, params[:ncredits].to_i)
      courses_taken = []
      if params[:math] == 'mac1140' || params[:math] == 'mac2311'
        courses_taken.push('MAC1105')
        courses_taken.push('MAC1140')
      end

      params[:taken].each do |course|
        courses_taken.push(course)
      end

      UserSession.instance.get_user.update_attribute(:courses_taken, courses_taken.join(','))
    end
  end
end
