# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create a default user if there isn't any 
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if AdminUser.find_by_email('admin@example.com').nil?

#Initialize the actions
actions = ["Create", "Read", "Modify", "Delete", "Assign", "Unassign"]

actions.each do | action |
  Action.create(name: action)
end

# Creates the permissions
permissions = ["Translate", "Clinic", "Excercise", "License", "User", "Profile"]

permissions.each do | name |
  Permission.create(name: name)
end

# Creates the scope groups
scope_groups = [["Languages", "A Group of different languages."],
                ["Clinic", "Privileges over the clinic."],
                ["Profiles", ["All the profiles"]]]

scope_groups.each do | name, description |
  ScopeGroup.create(name: name, description: description)
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
                         ["Excercise", "Clinic"], ["License", "Clinic"], ["User", "Clinic"]]

permission_scope_group.each do | permission, scope_group |
  PermissionScopeGroup.create(permission_id: Permission.find_by_name(permission).id,
                              scope_group_id: ScopeGroup.find_by_name(scope_group).id )
end

#Relation between scopes and permissions
#First the languages and the translate group
# scope_permission = [["Translate", "English"], ["Translate", "French"], ["Translate", "Portuguese"],
#                    ["Translate", "Spanish"],
#                    ["Excercise", "Create"], ["Excercise", "Read"], ["Excercise", "Modify"], ["Excercise", "Delete"],
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
  Profile.create(name: name)
end

#Link scopes and permissions with a profile
#[ Profile, Permission, Action, [ *Scope ] ]

profile_scope_permission = [["Author", "Excercise", "Create", []],
                           ["Author", "Excercise", "Modify", ["Own"]],
                           ["Author", "Excercise", "Delete", ["Own"]],
                           ["Author", "Excercise", "Create", ["Clinic"]],

                           ["Translator", "Translate", "Create", ["English", "Own"]],
                           ["Translator", "Translate", "Create", ["French", "Own"]],
                           ["Translator", "Translate", "Create", ["Portuguese", "Own"]],
                           ["Translator", "Translate", "Create", ["Spanish", "Own"]],

                           ["License administrator", "License", "Create", []],
                           ["License administrator", "License", "Read", ["License"]],
                           ["License administrator", "License", "Modify", ["Own"]],
                           ["License administrator", "License", "Delete", ["License"]],

                           ["License administrator", "User", "Create", []],
                           ["License administrator", "User", "Read", ["License"]],
                           ["License administrator", "User", "Modify", ["License"]],
                           ["License administrator", "User", "Delete", ["Own"]],

                           ["License administrator", "Profile", "Assign", ["Author"]],
                           ["License administrator", "Profile", "Assign", ["Translator"]],
                           ["License administrator", "Profile", "Assign", ["Media"]]
                           ]

profile_scope_permission.each do | profile, permission, action, profile_scopes |
  #sp = ScopePermission.where( permission_id: Permission.find_by_name( permission ).id,
                              #action_id: Action.find_by_name( action ).id ).first

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