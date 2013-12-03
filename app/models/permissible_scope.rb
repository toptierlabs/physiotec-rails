class PermissibleScope < ActiveRecord::Base
	#polymorphic relation
	belongs_to :permissible, :polymorphic=>true
	belongs_to :scope
	attr_accessible :scope_id

	#uniqueness
	validates :scope_id, :uniqueness => { :permissible_scope => :permissible }

end