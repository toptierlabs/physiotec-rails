# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create a default user if there isn't any 
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if AdminUser.find_by_email('admin@example.com').nil?


#Initialize the actions
actions = ["Create", "Read", "Modify", "Delete", "Assign", "Unassign"]

actions.each do | action |
	Action.create(name: action)
end

#Creates the default api license
ApiLicense.create(name: "Test API License", description: "Test License")



# Creates the permissions
permissions = [ ["Translate", Exercise.name],
								["Clinic", Clinic.name],
								["Exercise", Exercise.name],
								["License", License.name],
								["User", User.name], 
								["Permission", Permission.name],
								["Profile", Profile.name]]

permissions.each do | name, model |
	Permission.create(name: name, model_name: model, api_license_id: ApiLicense.first.id,)
end

# Creates the scope groups
scope_groups = [["Languages", "A Group of different languages."],
								["Clinic", "Privileges over the clinic."]]

scope_groups.each do | name, description |
	ScopeGroup.create(name: name, description: description, api_license_id: ApiLicense.first.id)
end

# Creates the scopes
scopes = [["English","Languages"], ["French", "Languages"], ["Portuguese", "Languages"],
				 ["Spanish", "Languages"], ["Own", "Clinic"], ["Clinic", "Clinic"],
				 ["License", "Clinic"], ["Api License", "Clinic"]]

scopes.each do | name, scope_group |
	Scope.create(name: name, scope_group_id: ScopeGroup.find_by_name(scope_group).id)
end

#Links the permissions and the scope groups
permission_scope_group = [["Translate", "Languages"], ["Translate", "Clinic"], ["Clinic", "Clinic"],
												 ["Exercise", "Clinic"], ["License", "Clinic"], ["User", "Clinic"], ["Permission", "Clinic"], ["Profile", "Clinic"]]

permission_scope_group.each do | permission, scope_group |
	PermissionScopeGroup.create(permission_id: Permission.find_by_name(permission).id,
															scope_group_id: ScopeGroup.find_by_name(scope_group).id )
end

#Relation between scopes and permissions
#First the languages and the translate group
# scope_permission = [["Translate", "English"], ["Translate", "French"], ["Translate", "Portuguese"],
#                    ["Translate", "Spanish"],
#                    ["Exercise", "Create"], ["Exercise", "Read"], ["Exercise", "Modify"], ["Exercise", "Delete"],
#                    ["Clinic", "Own"], ["Clinic", "Clinic"], ["Clinic", "License"],
#                    ["License", "Create"], ["License", "Read"], ["License", "Modify"], ["License", "Delete"],
#                    ["User", "Create"], ["User", "Read"], ["User", "Modify"], ["User", "Delete"]]

# scope_permission.each do | permission, scope |
#   ScopePermission.create(permission_id: Permission.find_by_name(permission).id,
#                               scope_id: Scope.find_by_name(scope).id )
# end

#Creation of profiles
profiles_list = ["Author", "Translator", "Physiotherapist", "Media",
								 "Patient", "License administrator", "Clinic Administrator"]

profiles_list.each do | name |
	Profile.create(name: name, api_license_id: ApiLicense.first.id)
end

#Link scopes and permissions with a profile
#[ Profile, Permission, Action, [ *Scope ] ]

profile_scope_permission = [["Author", "Exercise", "Create", ["Clinic"]],
													 ["Author", "Exercise", "Modify", ["Clinic"]],
													 ["Author", "Exercise", "Delete", ["Own"]],
													 ["Author", "Exercise", "Read", ["Clinic"]],

													 ["Translator", "Translate", "Create", ["English", "French", "Own"]],
													 ["Translator", "Translate", "Create", ["Portuguese", "Clinic"]],
													 ["Translator", "Translate", "Create", ["Spanish", "License"]],

													 ["License administrator", "License", "Create", ["Own"]],
													 ["License administrator", "License", "Read", ["API License"]],
													 ["License administrator", "License", "Modify", ["Own"]],
													 ["License administrator", "License", "Delete", ["License"]],

													 ["License administrator", "User", "Create", ["License"]],
													 ["License administrator", "User", "Read", ["Clinic"]],
													 ["License administrator", "User", "Modify", ["Clinic"]],
													 ["License administrator", "User", "Delete", ["Clinic"]],

													 ["License administrator", "Permission", "Create", ["License"]],
													 ["License administrator", "Permission", "Delete", ["Clinic"]],
													 ["License administrator", "Permission", "Read", ["Clinic"]],

													 ["License administrator", "Profile", "Assign", ["License"]],
													 ["License administrator", "Profile", "Unassign", ["License"]],

													 ["License administrator", "Exercise", "Create", ["Own"]],
													 ["License administrator", "Exercise", "Read", ["Clinic"]],
													 ["License administrator", "Exercise", "Modify", ["Clinic"]],
													 ["License administrator", "Exercise", "Delete", ["Api License"]]
													 ]

profile_scope_permission.each do | profile, permission, action, profile_scopes |
	#sp = ScopePermission.where( permission_id: Permission.find_by_name( permission ).id,
															#action_id: Action.find_by_name( action ).id ).firsts
	sp = ScopePermission.create( permission_id: Permission.find_by_name(permission).id,
															 action_id: Action.find_by_name( action ).id )# if sp.nil?
	profile_scopes.each do | scope |
		ScopePermissionGroupScope.create( scope_permission_id: sp.id,
																			scope_id: Scope.find_by_name(scope).id )
	end

	ProfileScopePermission.create(profile_id: Profile.find_by_name(profile).id,
																scope_permission_id: sp.id)
end

#Creates the relationship between a profile and his destination profiles (profile assignment)

profile_assignment = [["License administrator", "Clinic Administrator"],
										 ["License administrator", "Author"],
										 ["License administrator", "Translator"],
										 ["License administrator", "Physiotherapist"],
										 ["License administrator", "Media"],
										 ["License administrator", "Patient"],
										 ["Clinic Administrator", "Author"],
										 ["Clinic Administrator", "Translator"],
										 ["Clinic Administrator", "Physiotherapist"],
										 ["Clinic Administrator", "Media"]]

profile_assignment.each do | profile, destination_profile |
	ProfileAssignment.create(profile_id: Profile.find_by_name(profile).id,
													 destination_profile_id: Profile.find_by_name(destination_profile).id)
end

#Create a license
l = License.new(maximum_clinics: 10, maximum_users: 100, first_name: 'test first name',
	last_name: 'test name', email: 'mdehorta@toptierlabs.com', phone: '+59898335787')
l.api_license = ApiLicense.first
l.save

l2 = License.new(maximum_clinics: 10, maximum_users: 100, first_name: 'test first name 2',
	last_name: 'test name 2', email: 'mdehorta2@toptierlabs.com', phone: '+59898335787')
l2.api_license = ApiLicense.first
l2.save

#Create a clinic
c1 = Clinic.create(name: 'test clinic 1', license_id: l.id)
c2 = Clinic.create(name: 'test clinic 2', license_id: l.id)

c3 = Clinic.create(name: 'test clinic 3', license_id: l2.id)

#Creates a default user

users = []
contexts = [c1,c2,c3, l, l2, ApiLicense.first]
for i in 0..5
	u = User.create(:email => "dev-test#{i+1}@physiotec.org",:api_license_id=>1, :first_name=> "Test User #{i+1}", :last_name=>'Dev')
	u.password = 'pepepepe'
	u.password_confirmation = 'pepepepe'
	u.confirm!
	u.profiles << Profile.find_by_name('License administrator')
	u.context = contexts[i%6]
	u.assign_scopes_permissions
	u.save
	users << u
end


#Create exercises
for i in 0..19
	e = Exercise.new(title: "test exercise #{i+1}", description: 'test description', owner_id: users[i%5].id)
	e.context = contexts[i%6]
	e.save
end


# id, title, description, context_id, context_type, license_id, owner_id, created_at, updated_at
