class SessionController < ApplicationController
  def dashboard
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
      return
    end

    classes_taken = UserSession.instance.get_user.courses_taken.split(',')
    courses = []

    classes_taken.each do |course|
      courses.push(Course.where(:course_code => course).first)
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
  end
end
