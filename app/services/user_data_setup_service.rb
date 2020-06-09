# frozen_string_literal: true

# Great explanation on non-model callback options:
# http://blog.mohamad.im/2015/09/20/four-alternatives-to-using-activerecord-callbacks-and-observers.html

class UserDataSetupService
  class << self
    def setup(user)
      create_post_types(user)
      create_categories(user)
    end

    private

    def create_categories(user)
      user.categories.create!([
                                { name: 'Citizenship' },
                                { name: 'Health' },
                                { name: 'Leadership' },
                                { name: 'Networking & Friendship' },
                                { name: 'Skills & Competencies' },
                              ])
    end

    def create_post_types(user)
      user.post_types.create!([
                                { name: 'Gratitude' },
                                { name: 'TIL' },
                              ])

      merit_template = <<~MERIT
        ## Project
        tbd

        ## Problem
        tbd

        ## How I solved it
        tbd

        ## Key Skills/Technologies Used
        tbd

        ## Special Concerns
        tbd
      MERIT

      user.post_types.create!(
        name: 'Merit',
        description_template: merit_template
      )

      praise_template = <<~PRAISE
        ## Given By
        tbd

        ## Context
        tbd

        ## Praise Given
        tbd
      PRAISE

      user.post_types.create!(
        name: 'Praise',
        description_template: praise_template
      )
    end
  end
end
