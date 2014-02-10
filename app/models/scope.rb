class Scope
  @@scopes = []

  attr_reader :name , :id

	include Comparable


  def <=> value
    @id <=> value.id
  end

  def self.all
    @@scopes
  end

  def self.find(params)
    _id = params.to_i
    if TYPES.values.include? _id
      @@scopes[(params.to_i - 1)]
    else
      nil
    end
  end

  def self.find_by(params = {})
    #sanitize the params
    _id = params[:id].to_i if params[:id].present? 
    _name = params[:name].to_sym if params[:name].present?

    if _id.present? && _name.present?
      return nil unless TYPES[_name] == _id
    end

    if _id.present?
      self.find(_id)
    elsif _name.present?
      self.find(TYPES[_name])
    end
  end


  private

    def initialize(params = {})
      @id = params[:scope_id]
      @name = TYPES.keys[@id-1]
    end

    TYPES = { user: 1, clinic: 2, license: 3, api_license: 4 }

    TYPES.each do |k, v|
      #for each scope creates a new method for finding abilities with the given scope
      define_singleton_method("#{k}_user_abilities".as_sym) {
        UserAbility.where(scope: v)
      }

      define_singleton_method("#{k}_profile_abilities".as_sym) {
        ProfileAbility.where(scope: v)
      }

      define_singleton_method("#{k}_scope") { 
        @@scopes[v-1]
      }

      define_method("is_#{k}?") { 
        @id == v
      }

      #for each action creates a new method for getting the scope id
      define_singleton_method("#{k}_scope_id".as_sym) { v }

      @@scopes << self.new(scope_id: v)
    end

end
