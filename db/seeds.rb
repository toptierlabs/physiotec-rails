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
permissions = [ ["Clinic", Clinic.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
                ["Exercise", Exercise.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["License", License.name, Scope.api_license_scope.id, Scope.license_scope.id],
                ["User", User.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["Permission", Permission.name, Scope.api_license_scope.id, Scope.api_license_scope.id],
                ["Profile", Profile.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
                ["AssignProfile", UserProfile.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["Module", Category.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
                ["Section", SectionDatum.name, Scope.api_license_scope.id, Scope.clinic_scope.id],
                ["ExerciseIllustration",ExerciseIllustration.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["ExerciseImage", ExerciseImage.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["ExerciseVideo", ExerciseVideo.name, Scope.api_license_scope.id, Scope.user_scope.id],
                ["UserContexts", UserContext.name, Scope.api_license_scope.id, Scope.user_scope.id]
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
  p.save
end


# profile_abilities = {
#   :"Api Administrator" =>
#     [
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("License").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("License").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("License").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("License").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("User").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       { permission_id: Permission.find_by_name("User").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.assign_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.unassign_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("UserContexts").id, action_id: Action.assign_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("UserContexts").id, action_id: Action.unassign_action.id, scope_id: Scope.api_license_scope.id},

#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.create_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.update_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.show_action.id, scope_id: Scope.api_license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.destroy_action.id, scope_id: Scope.api_license_scope.id}
#     ],

#   :"License Administrator" =>
#     [
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("User").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.assign_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.unassign_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("UserContexts").id, action_id: Action.assign_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("UserContexts").id, action_id: Action.unassign_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("License").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id}
#     ],

#   :"Clinic Administrator" =>
#     [
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("User").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("User").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Profile").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.assign_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("AssignProfile").id, action_id: Action.unassign_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Clinic").id, action_id: Action.show_action.id, scope_id: Scope.clinic_scope.id}
#     ],

#   :"Author" =>
#     [
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.create_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.destroy_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},

#       {permission_id: Permission.find_by_name("User").id, action_id: Action.show_action.id, scope_id: Scope.user_scope.id},
#     ],

#   :"Translator" =>
#     [
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Exercise").id, action_id: Action.translate_action.id, scope_id: Scope.license_scope.id, language_ids: Language.pluck(:id)},

#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Section").id, action_id: Action.translate_action.id, scope_id: Scope.license_scope.id, language_ids: Language.pluck(:id)},

#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.update_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.show_action.id, scope_id: Scope.license_scope.id},
#       {permission_id: Permission.find_by_name("Module").id, action_id: Action.translate_action.id, scope_id: Scope.license_scope.id, language_ids: Language.pluck(:id)},

#       {permission_id: Permission.find_by_name("User").id, action_id: Action.show_action.id, scope_id: Scope.user_scope.id}
#     ]
#   }

# profile_abilities.each do |k, v|
#   p = Profile.find_by_name(k)
#   p.profile_abilities_attributes=v
#   p.save

# end


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
clinics = [c1,c2,c3, l, l2]
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
    u.api_licenses << ApiLicense.first


  elsif (i%3==1)
    u.profiles << Profile.find_by_name('License administrator')
    u.profiles << Profile.find_by_name('Translator')
    u.licenses << licenses[i%licenses.length]
  else
    u.profiles << Profile.find_by_name('Clinic administrator')
    u.clinics << clinics[i%clinics.length]
  end
  u.apply_profiles_abilities
  u.save
  users << u
end

contexts = [c1,c2,c3, l, l2, ApiLicense.first]
#Create exercises
for i in 0..20
  e = Exercise.new(title: "test exercise #{i+1}", description: 'test description')
  e.owner = users[i%5]
  e.api_license =  ApiLicense.first
  e.context = contexts[i%6]
  e.code = "code_#{i}"
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
