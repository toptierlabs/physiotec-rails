# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create a default user if there isn't any 
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if AdminUser.find_by_email('admin@example.com').nil?

#Creates the default ApiLicense
api_lic = ApiLicense.create(name: "Test ApiLicense", description: "Test License")
api_lic.public_api_key = "PUBLIC_KEY" 
api_lic.public_api_key = "SECRET_KEY"

# Creates languages

languages = [["en","English", nil], ["es","Spanish", ApiLicense.first], ["pt","Portuguese",ApiLicense.first], ["fr","French",ApiLicense.first]]

languages.each do |v|
	l = Language.new(locale: v[0], description: v[1])
	l.api_license = v[2]
	l.save
end

# Creates the permissions
permissions = [ ["Clinic", Clinic.name, Scope.api_license_scope.id, Scope.license_scope.id],
								["Exercise", Exercise.name, Scope.api_license_scope.id, Scope.own_scope.id],
								["License", License.name, Scope.api_license_scope.id, Scope.api_license_scope.id],
								["User", User.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
								["Permission", Permission.name, Scope.api_license_scope.id, Scope.api_license_scope.id],
								["Profile", Profile.name, Scope.api_license_scope.id, Scope.api_license_scope.id],
								["Module", Category.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
								["Section", SectionDatum.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
								["ExerciseIllustration",ExerciseIllustration.name, Scope.api_license_scope.id, Scope.own_scope.id],
								["ExerciseImage", ExerciseImage.name, Scope.api_license_scope.id, Scope.own_scope.id],
								["ExerciseVideo", ExerciseVideo.name, Scope.api_license_scope.id, Scope.own_scope.id]
							]

permissions.each do | name, model, maxs, mins |
	Permission.create(name: name, model_name: model, maximum_scope_id: maxs, minimum_scope_id: mins)
end


#Creation of profiles
profiles_list = [["Author", ApiLicense.first], ["Translator", ApiLicense.first], ["Physiotherapist", ApiLicense.first], ["Media", ApiLicense.first],
				["Patient", ApiLicense.first], ["License administrator", nil, true], ["Clinic Administrator",  nil, true], ["API Administrator", nil, true]]

profiles_list.each do | v |
	p = Profile.new(name: v[0])
	p.api_license = v[1]
	#p.protected = v[2]
	p.save
end

#Link scopes and permissions with a profile
#[ Profile, Permission, Action, [ *Scope ] ]

# profile_scope_permission = [
# 														["Author", "Exercise", "Create", ["Clinic"]],
# 														["Author", "Exercise", "Modify", ["Clinic"]],
# 														["Author", "Exercise", "Delete", ["Own"]],
# 														["Author", "Exercise", "Read", ["Clinic"]],

# 														["Translator", "Exercise", "Create", ["Clinic"]],
# 														["Translator", "Exercise", "Modify", ["Clinic"]],
# 														["Translator", "Exercise", "Delete", ["Own"]],
# 														["Translator", "Exercise", "Read", ["Clinic"]],
# 														["Translator", "Clinic", "Read", ["License"]],
# 														["Translator", "Section", "Create", ["License"]],
# 														["Translator", "Section", "Read", ["License"]],
# 														["Translator", "Section", "Modify", ["License"]],
# 														["Translator", "Section", "Delete", ["License"]],
# 														["Translator", "Module", "Translate", ["en", "pt", "es", "fr", "ApiLicense"]],
# 														["Translator", "Section", "Translate", ["en", "pt", "es", "fr", "ApiLicense"]],
# 														["Translator", "Exercise", "Translate", ["ApiLicense", "en", "pt", "fr", "es"]],

# 														["License administrator", "User", "Create", ["License"]],
# 														["License administrator", "User", "Read", ["License"]],
# 														["License administrator", "User", "Modify", ["License"]],
# 														["License administrator", "User", "Delete", ["License"]],
# 														["License administrator", "Clinic", "Create", ["License"]],
# 														["License administrator", "Clinic", "Delete", ["License"]],
# 														["License administrator", "Clinic", "Read", ["License"]],
# 														["License administrator", "Clinic", "Modify", ["License"]],
# 														["License administrator", "Profile", "Assign", ["License"]],
# 														["License administrator", "Profile", "Unassign", ["License"]],
# 														["License administrator", "Exercise", "Create", ["License"]],
# 														["License administrator", "Exercise", "Read", ["License"]],
# 														["License administrator", "Exercise", "Modify", ["License"]],
# 														["License administrator", "Exercise", "Delete", ["License"]],
# 														["License administrator", "Module", "Create", ["License"]],
# 														["License administrator", "Module", "Read", ["License"]],
# 														["License administrator", "Module", "Modify", ["License"]],
# 														["License administrator", "Module", "Delete", ["License"]],
# 														["License administrator", "Section", "Create", ["License"]],
# 														["License administrator", "Section", "Read", ["License"]],
# 														["License administrator", "Section", "Modify", ["License"]],
# 														["License administrator", "Section", "Delete", ["License"]],

# 														["Clinic administrator", "User", "Create", ["Clinic"]],
# 														["Clinic administrator", "User", "Read", ["Clinic"]],
# 														["Clinic administrator", "User", "Modify", ["Clinic"]],
# 														["Clinic administrator", "User", "Delete", ["Clinic"]],
# 														["Clinic administrator", "Profile", "Assign", ["Clinic"]],
# 														["Clinic administrator", "Profile", "Unassign", ["Clinic"]],
# 														["Clinic administrator", "Exercise", "Create", ["Clinic"]],
# 														["Clinic administrator", "Exercise", "Read", ["Clinic"]],
# 														["Clinic administrator", "Exercise", "Modify", ["Clinic"]],
# 														["Clinic administrator", "Exercise", "Delete", ["Clinic"]],
# 														["Clinic administrator", "Exercise", "Create", ["Clinic"]],

# 														["Clinic Administrator", "Section", "Create", ["Clinic"]],
# 														["Clinic Administrator", "Section", "Read", ["Clinic"]],
# 														["Clinic Administrator", "Section", "Modify", ["Clinic"]],
# 														["Clinic Administrator", "Section", "Delete", ["Clinic"]],
# 														["Clinic Administrator", "Module", "Create", ["Clinic"]],
# 														["Clinic Administrator", "Module", "Read", ["Clinic"]],
# 														["Clinic Administrator", "Module", "Modify", ["Clinic"]],
# 														["Clinic Administrator", "Module", "Delete", ["Clinic"]],

# 														["API Administrator", "Section", "Create", ["ApiLicense"]],
# 														["API Administrator", "Section", "Read", ["ApiLicense"]],
# 														["API Administrator", "Section", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Section", "Delete", ["ApiLicense"]],
# 														["API Administrator", "License", "Create", ["ApiLicense"]],
# 														["API Administrator", "License", "Read", ["ApiLicense"]],
# 														["API Administrator", "License", "Modify", ["ApiLicense"]],
# 														["API Administrator", "License", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Clinic", "Create", ["ApiLicense"]],
# 														["API Administrator", "Clinic", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Clinic", "Read", ["ApiLicense"]],
# 														["API Administrator", "Clinic", "Modify", ["ApiLicense"]],
# 														["API administrator", "Exercise", "Create", ["ApiLicense"]],
# 														["API administrator", "Exercise", "Read", ["ApiLicense"]],
# 														["API administrator", "Exercise", "Modify", ["ApiLicense"]],
# 														["API administrator", "Exercise", "Delete", ["ApiLicense"]],
# 														["API administrator", "Exercise", "Create", ["ApiLicense"]],
# 														["API Administrator", "User", "Create", ["ApiLicense"]],
# 														["API Administrator", "User", "Read", ["ApiLicense"]],
# 														["API Administrator", "User", "Modify", ["ApiLicense"]],
# 														["API Administrator", "User", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Create", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Read", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Assign", ["ApiLicense"]],
# 														["API Administrator", "Permission", "Unassign", ["ApiLicense"]],
# 														["API Administrator", "ScopeGroup", "Create", ["ApiLicense"]],
# 														["API Administrator", "ScopeGroup", "Delete", ["ApiLicense"]],
# 														["API Administrator", "ScopeGroup", "Read", ["ApiLicense"]],
# 														["API Administrator", "ScopeGroup", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Scope", "Create", ["ApiLicense"]],
# 														["API Administrator", "Scope", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Scope", "Read", ["ApiLicense"]],
# 														["API Administrator", "Scope", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Profile", "Assign"],
# 														["API Administrator", "Profile", "Unassign"],
# 														["API Administrator", "Profile", "Create", ["ApiLicense"]],
# 														["API Administrator", "Profile", "Read", ["ApiLicense"]],
# 														["API Administrator", "Profile", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Profile", "Delete", ["ApiLicense"]],
# 														["API Administrator", "Module", "Create", ["ApiLicense"]],
# 														["API Administrator", "Module", "Read", ["ApiLicense"]],
# 														["API Administrator", "Module", "Modify", ["ApiLicense"]],
# 														["API Administrator", "Module", "Delete", ["ApiLicense"]]

# 													]



# profile_scope_permission.each do | profile, permission, action, profile_scopes |
# 	sp = nil
# 	exists = false
# 	sps = ScopePermission.where(permission_id: Permission.find_by_name(permission).id,
# 												      action_id: Action.find_by_name(action).id )
# 	if sps.present?
# 		#check if the scopes are equal
# 		sps.each do |v|
# 			exists = (v.scope_ids - Scope.where(name: profile_scopes).pluck(:id)).empty? &&
# 			         (Scope.where(name: profile_scopes).pluck(:id) - v.scope_ids).empty?
# 			sp = v if exists
# 			break if exists
# 		end		
# 	end

# 	if (sps.empty?) || (!exists)
# 		sp = ScopePermission.create( permission_id: Permission.find_by_name(permission).id,
# 																 action_id: Action.find_by_name( action ).id )# if sp.nil?
# 		profile_scopes.each do | scope |
# 			ScopePermissionGroupScope.create( scope_permission_id: sp.id,
# 			scope_id: Scope.find_by_name(scope).id )
# 		end unless profile_scopes.nil?
# 	end

# 	ProfileScopePermission.create(profile_id: Profile.find_by_name(profile).id,
# 																scope_permission_id: sp.id)
# end

# #Creates the relationship between a profile and his destination profiles (profile assignment)

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
											["API Administrator", "API Administrator"],
											["API Administrator", "Translator"]
											
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
	u = User.create :email => "test-#{i+1}@email.com",
		              :api_license_id=>1,
		              :first_name=> "Test User #{i+1}",
		              :last_name=>'Dev'

	u.password = 'pepepepe'
	u.password_confirmation = 'pepepepe'
	u.confirm!
	u.api_license = ApiLicense.first
	if (i%3==0)
		u.profiles << Profile.find_by_name('API Administrator')
		u.profiles << Profile.find_by_name('Translator')
		u.context = ApiLicense.first


	elsif (i%3==1)
		u.profiles << Profile.find_by_name('License administrator')
		u.profiles << Profile.find_by_name('Translator')
		u.context = licenses[i%licenses.length]
	else
		u.profiles << Profile.find_by_name('Clinic administrator')
		u.context = clinics[i%clinics.length]
	end
	#u.apply_profiles
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

languages = [ ['en', 'English'], ['fr', 'French'], ['pt', 'Portuguese'], ['es', 'Spanish'] ] 

languages.each do |v|
	l = Language.new(locale: v[0], description: v[1] )
	l.api_license = ApiLicense.first
end


section_data = {:"Body Parts"=>["abdominals",
																	"ankle/foot",
																	"cervical",
																	"chest",
																	"elbow",
																	"hip",
																	"jaw",
																	"knee",
																	"lumbar",
																	"pelvis",
																	"scapula",
																	"shoulder",
																	"thoracic",
																	"wrist/hand"],
										:"Movements"=>["abduction",
																"adduction",
																"circumduction",
																"depression",
																"deviation verticale",
																"elevation",
																"eversion",
																"extension",
																"external rotation",
																"flexion",
																"horizontal abduction",
																"horizontal adduction",
																"internal rotation",
																"inversion",
																"lateral flexion",
																"plantarflexion",
																"pronation/supination",
																"protraction",
																"retraction",
																"rotation",
																"ulnar deviation"],
										:"Objectives"=>["AAROM",
																	"AROM",
																	"gait/walking",
																	"isometric",
																	"myofascial release",
																	"neural mobility",
																	"posture",
																	"PROM",
																	"proprioception",
																	"propulsion",
																	"repeated",
																	"stability",
																	"stabilization",
																	"strengthening",
																	"stretching",
																	"swelling control",
																	"transfers/positioning"],
										:"Positions"=>["crook lying",
																	"kneeling",
																	"long sitting",
																	"on 1 foot",
																	"on all fours",
																	"prone",
																	"side lying",
																	"sitting",
																	"standing",
																	"supine"],
										:"Others"=>["ball",
															"belt",
															"bosu",
															"chair",
															"elastic",
															"floor",
															"overhead pulley",
															"peanut ball",
															"pillow",
															"roller",
															"step/stair",
															"stick/cane",
															"swiss ball",
															"table",
															"towel",
															"wall",
															"weight"]}

section_data.each do |k, v|
	sd = SectionDatum.new name: k
	sd.api_license = ApiLicense.first
	sd.context = ApiLicense.first
	sd.save
	v.each do |ssd|
		k = SubsectionDatum.new name: ssd
		k.section_datum_id = sd.id
		k.save    
		       
	end
end
