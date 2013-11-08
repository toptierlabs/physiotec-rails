# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create a default user if there isn't any 
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if AdminUser.find_by_email('admin@example.com').nil?

# Creates the permissions
permissions = ["Translate", "Clinic", "Excercise"]

permissions.each do | name |
  Permission.create(name: name)
end

# Creates the scope groups
scope_groups = [["Common", "Common permissions, like create, modify or delete."], ["Languages", "A Group of different languages."],
                ["Clinic", "Privileges over the clinic."]]

scope_groups.each do | name, description |
  ScopeGroup.create(name: name, description: description)
end

# Creates the scopes
scopes = [["Create", "Common"], ["Modify", "Common"], ["Delete", "Common"],
         ["English","Languages"], ["French", "Languages"], ["Portuguese", "Languages"],
         ["Spanish", "Languages"], ["Own", "Clinic"], ["Clinic", "Clinic"],
         ["License", "Clinic"]]

scopes.each do | name, scope_group |
  Scope.create(name: name, scope_group_id: ScopeGroup.find_by_name(scope_group).id)
end

#Links the permissions and the scope groups
permission_scope_group = [["Translate", "Languages"], ["Excercise", "Common"],
                          ["Clinic", "Clinic"]]

permission_scope_group.each do | permission, scope_group |
  PermissionScopeGroup.create(permission_id: Permission.find_by_name(permission).id,
                            scope_group_id: ScopeGroup.find_by_name(scope_group).id )
end

#Relation between scopes and permissions
#First the languages and the translate group
scope_permission = [["Translate", "English"], ["Translate", "French"], ["Translate", "Portuguese"],
                   ["Translate", "Spanish"], ["Excercise", "Create"], ["Excercise", "Modify"],
                   ["Excercise", "Delete"], ["Clinic", "Own"], ["Clinic", "Clinic"],
                   ["Clinic", "License"]]

scope_permission.each do | permission, scope |
  ScopePermission.create(permission_id: Permission.find_by_name(permission).id,
                            scope_id: Scope.find_by_name(scope).id )
end

#Creation of profiles
profiles_list = ["Author", "Translator", "Physiotherapist", "Media",
                 "Patient", "License administrator", "Clinic Administrator"]

profiles_list.each do | name |
  Profile.create(name: name)
end

#Link scopes and permissions with a profile
profile_scope_permission = [["Author", ["Excercise", "Create"]],
                           ["Author", ["Excercise", "Modify"]],
                           ["Author", ["Excercise", "Delete"]],
                           ["Translator", ["Translate", "English"]],
                           ["Translator", ["Translate", "French"]],
                           ["Translator", ["Translate", "Portuguese"]],
                           ["Translator", ["Translate", "Spanish"]]]



profile_scope_permission.each do | profile, scope_permission |
  ProfileScopePermission.create(profile_id: Profile.find_by_name(profile).id,
                                scope_permission_id: ScopePermission.where(
                                                      permission_id:Permission.find_by_name(scope_permission[0]).id,
                                                      scope_id:Scope.find_by_name(scope_permission[1]).id
                                                      ).first.id)
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
  ProfileAssignment.create(profile: Profile.find_by_name(profile),
                           destination_profile: Profile.find_by_name(destination_profile))
end