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
								["ScopeGroup", ScopeGroup.name],
								["Scope", Scope.name],
								["Profile", Profile.name]]

permissions.each do | name, model |
	Permission.create(name: name, model_name: model, api_license_id: ApiLicense.first.id,)
end

# Creates the scope groups
scope_groups = [["Languages", "A Group of different languages."],
								["Context", "Privileges over the clinic."]]

scope_groups.each do | name, description |
	ScopeGroup.create(name: name, description: description, api_license_id: ApiLicense.first.id)
end

# Creates the scopes
scopes = [["English","Languages"], ["French", "Languages"], ["Portuguese", "Languages"],
				 ["Spanish", "Languages"], ["Own", "Context"], ["Clinic", "Context"],
				 ["License", "Context"], ["Api License", "Context"]]

scopes.each do | name, scope_group |
	Scope.create(name: name, scope_group_id: ScopeGroup.find_by_name(scope_group).id)
end

#Links the permissions and the scope groups
permission_scope_group = [["Translate", "Languages"], ["Translate", "Context"], ["Clinic", "Context"],
												 ["Exercise", "Context"], ["License", "Context"], ["User", "Context"], ["Profile", "Context"],
												 ["ScopeGroup", "Context"], ["Scope", "Context"], ["Profile", "Context"]]

permission_scope_group.each do | permission, scope_group |
	PermissionScopeGroup.create(permission_id: Permission.find_by_name(permission).id,
															scope_group_id: ScopeGroup.find_by_name(scope_group).id )
end

#Creation of profiles
profiles_list = ["Author", "Translator", "Physiotherapist", "Media",
				"Patient", "License administrator", "Clinic Administrator", "API Administrator"]

profiles_list.each do | name |
	Profile.create(name: name, api_license_id: ApiLicense.first.id)
end

#Link scopes and permissions with a profile
#[ Profile, Permission, Action, [ *Scope ] ]

profile_scope_permission = [
														["Author", "Exercise", "Create", ["Clinic"]],
														["Author", "Exercise", "Modify", ["Clinic"]],
														["Author", "Exercise", "Delete", ["Own"]],
														["Author", "Exercise", "Read", ["Clinic"]],

														["Translator", "Translate", "Create", ["English", "French", "Own"]],
														["Translator", "Translate", "Create", ["Portuguese", "Clinic"]],
														["Translator", "Translate", "Create", ["Spanish", "License"]],

														["License administrator", "User", "Create", ["License"]],
														["License administrator", "User", "Read", ["License"]],
														["License administrator", "User", "Modify", ["License"]],
														["License administrator", "User", "Delete", ["License"]],
														["License administrator", "Clinic", "Create", ["License"]],
														["License administrator", "Clinic", "Delete", ["License"]],
														["License administrator", "Clinic", "Read", ["License"]],
														["License administrator", "Clinic", "Modify", ["License"]],
														["License administrator", "Profile", "Assign", ["License"]],
														["License administrator", "Profile", "Unassign", ["License"]],

														["License administrator", "Exercise", "Create", ["License"]],
														["License administrator", "Exercise", "Read", ["License"]],
														["License administrator", "Exercise", "Modify", ["License"]],
														["License administrator", "Exercise", "Delete", ["License"]],

														["API Administrator", "License", "Create", ["API License"]],
														["API Administrator", "License", "Read", ["API License"]],
														["API Administrator", "License", "Modify", ["API License"]],
														["API Administrator", "License", "Delete", ["API License"]],
														["API Administrator", "Clinic", "Create", ["Api License"]],
														["API Administrator", "Clinic", "Delete", ["Api License"]],
														["API Administrator", "Clinic", "Read", ["Api License"]],
														["API Administrator", "Clinic", "Modify", ["Api License"]],
														["API Administrator", "User", "Create", ["Api License"]],
														["API Administrator", "User", "Read", ["Api License"]],
														["API Administrator", "User", "Modify", ["Api License"]],
														["API Administrator", "User", "Delete", ["Api License"]],
														["API Administrator", "Permission", "Create", ["Api License"]],
														["API Administrator", "Permission", "Delete", ["Api License"]],
														["API Administrator", "Permission", "Read", ["Api License"]],
														["API Administrator", "Permission", "Modify", ["Api License"]],
														["API Administrator", "Permission", "Assign", ["Api License"]],
														["API Administrator", "Permission", "Unassign", ["Api License"]],
														["API Administrator", "ScopeGroup", "Create", ["Api License"]],
														["API Administrator", "ScopeGroup", "Delete", ["Api License"]],
														["API Administrator", "ScopeGroup", "Read", ["Api License"]],
														["API Administrator", "ScopeGroup", "Modify", ["Api License"]],
														["API Administrator", "Scope", "Create", ["Api License"]],
														["API Administrator", "Scope", "Delete", ["Api License"]],
														["API Administrator", "Scope", "Read", ["Api License"]],
														["API Administrator", "Scope", "Modify", ["Api License"]],
														["API Administrator", "Profile", "Assign", ["License"]],
														["API Administrator", "Profile", "Unassign", ["License"]],
														["API Administrator", "Profile", "Create", ["Api License"]],
														["API Administrator", "Profile", "Read", ["Api License"]],
														["API Administrator", "Profile", "Modify", ["Api License"]],
														["API Administrator", "Profile", "Delete", ["Api License"]]
														]


profile_scope_permission.each do | profile, permission, action, profile_scopes |
	#sp = ScopePermission.where( permission_id: Permission.find_by_name( permission ).id,
															#action_id: Action.find_by_name( action ).id ).firsts
	sp = ScopePermission.create( permission_id: Permission.find_by_name(permission).id,
															 action_id: Action.find_by_name( action ).id )# if sp.nil?
	profile_scopes.each do | scope |
		ScopePermissionGroupScope.create( scope_permission_id: sp.id,
		scope_id: Scope.find_by_name(scope).id )
	end unless profile_scopes.nil?

	ProfileScopePermission.create(profile_id: Profile.find_by_name(profile).id,
																scope_permission_id: sp.id)
end

#Creates the relationship between a profile and his destination profiles (profile assignment)

profile_assignment = [
											["License administrator", "Clinic Administrator"],
											["License administrator", "Author"],
											["License administrator", "Translator"],
											["License administrator", "Physiotherapist"],
											["License administrator", "Media"],
											["License administrator", "Patient"],
											["License administrator", "License administrator"],
											["Clinic Administrator", "Author"],
											["Clinic Administrator", "Translator"],
											["Clinic Administrator", "Physiotherapist"],
											["Clinic Administrator", "Media"],
											["API Administrator", "Clinic Administrator"],
											["API Administrator", "License administrator"],
											["API Administrator", "API Administrator"]
										]

profile_assignment.each do | profile, destination_profile |
	ProfileAssignment.create(profile_id: Profile.find_by_name(profile).id,
													 destination_profile_id: Profile.find_by_name(destination_profile).id)
end

#Create a license
l = License.new(maximum_clinics: 10, maximum_users: 100, first_name: 'test first name',
	last_name: 'test name', email: 'mdehorta@toptierlabs.com', phone: '+59898335787',company_name: "Company 1")
l.api_license = ApiLicense.first
l.save

l2 = License.new(maximum_clinics: 10, maximum_users: 100, first_name: 'test first name 2',
	last_name: 'test name 2', email: 'mdehorta2@toptierlabs.com', phone: '+59898335787',company_name: "Company 2")
l2.api_license = ApiLicense.first
l2.save

#Create a clinic
c1 = Clinic.new(name: 'test clinic 1', license_id: l.id)
c1.api_license = ApiLicense.first
c1.save

c2 = Clinic.new(name: 'test clinic 2', license_id: l.id)
c2.api_license = ApiLicense.first
c2.save

c3 = Clinic.new(name: 'test clinic 3', license_id: l2.id)
c3.api_license = ApiLicense.first
c3.save
#Creates a default user

users = []
clinics = [c1,c2,c3, l, l2, ApiLicense.first]
licenses = [l, l2]
for i in 0..5
	u = User.create(:email => "test-#{i+1}@toptierlabs.com",:api_license_id=>1, :first_name=> "Test User #{i+1}", :last_name=>'Dev')
	u.password = 'pepepepe'
	u.password_confirmation = 'pepepepe'
	u.confirm!
	u.api_license = ApiLicense.first
	if (i%3==0)
		u.profiles << Profile.find_by_name('API Administrator')
		u.context = ApiLicense.first
	elsif (i%3==1)
		u.profiles << Profile.find_by_name('License administrator')
		u.context = licenses[i%licenses.length]
	else
		u.profiles << Profile.find_by_name('Clinic administrator')
		u.context = clinics[i%clinics.length]
	end
	u.save
	users << u
end

contexts = [c1,c2,c3, l, l2, ApiLicense.first]
#Create exercises
for i in 0..20
	e = Exercise.new(title: "test exercise #{i+1}", description: 'test description', owner_id: users[i%5].id)
	e.api_license =  ApiLicense.first
	e.context = contexts[i%6]
	e.save
end


# id, title, description, context_id, context_type, license_id, owner_id, created_at, updated_at
