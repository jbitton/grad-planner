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

    unless params['demo-name'].nil? || params[:classtype].nil?
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

      if UserSession.instance.get_user.credits_taken < 90
        potential_classes.reject! { |major_c| major_c.course_code == 'EGN4950C' || major_c.course_code == 'COT4935' }
      end

      if UserSession.instance.get_user.credits_taken < 60
        potential_classes.reject! { |major_c| major_c.course_code == 'CEN4214' }
      end

      if UserSession.instance.get_user.credits_taken > 30
        potential_classes.reject! { |major_c| major_c.course_code == 'EGN1002' }
      end

      num_classes = params['demo-name']
      core_or_elective = params[:classtype]

      i = 0
      recommended = potential_classes.dup

      unless recommended.count <= num_classes.to_i
        major = UserSession.instance.get_user.major_1
        if core_or_elective == 'core'
          while recommended.count > num_classes.to_i && i < recommended.count
            if recommended[i].nil?
              recommended.delete_at(i)
            else
              unless recommended[i].core_for_majors.include?(major.to_s)
                recommended.delete_at(i)
              end
            end
            i = i + 1
          end
        elsif core_or_elective == 'elective'
          while recommended.count > num_classes.to_i && i < recommended.count
            if recommended[i].nil?
              recommended.delete_at(i)
            else
              if recommended[i].core_for_majors.include?(major.to_s)
                recommended.delete_at(i)
              end
            end
            i = i + 1
          end
        end

        if recommended.count >= num_classes.to_i
          recommended.sort_by { |rec| rec.core_for_majors.size }

          i = recommended.count - 1
          until i == num_classes.to_i - 1
            recommended.delete_at(i)
            i = i - 1
          end
        end
      end

      render partial: 'results', layout: '/layouts/session', locals: { active: 'generate', recommended: recommended,
                                                                       potential: potential_classes }
    end
  end

  def settings
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
      return
    end

    unless params[:fname].nil?
      unless params[:lname] && params[:major] && params[:ncredits] && params[:math] && params[:taken]
        render partial: 'settings', layout: '/layouts/session', locals: { active: 'settings', invalid: true }
        return
      end
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
