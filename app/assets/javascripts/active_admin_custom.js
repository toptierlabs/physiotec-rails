$( document ).ready(function() {

	//get pathname of the current http object
	var pathname = window.location.pathname;

	//define a reg exp
	var reg_exp_patt=/((admin\/scope_permissions\/\d+\/edit)|(admin\/scope_permissions\/new))$/i;

	//if the pathname matches with 'scope_permissions/new' or 'scope_permissions/:number/edit'
	if (reg_exp_patt.test(pathname)) {
		//function that updates the select scope tag to valid inputs
		 var change_scope_elements = function (id_value) {
			if ((id_value != null) || id_value) {
		    	//clean the current list of scopes
		    	$('#scope_permission_scope_id').empty();
		    	//url ajax request
		    	url = '/admin/permissions/' + id_value + '/scopes';
		    	//function ajax callback
		        callback = function (value) {
		        	dom_element = $('#scope_permission_scope_id');
		        	if (value.length == 0) {
		        		dom_element.val(0);
		        	};
		        	value.forEach(function(entry) {
		        		dom_element.append('<option value="' + entry['id'] + '">' + entry['name'] + '</option>');
					});
		        	//if there is a selected scope
					if (window.saved_scope)
					{
						$('#scope_permission_scope_id').val(saved_scope);
					}
					window.saved_scope = undefined;
		        }
		        //ajax callback
		    	$.get(url,callback);
	    	}
		};

	    $('#scope_permission_permission_id').change(function() {
	    	change_scope_elements( $(this).val() );
	    });

	    //save the selected scope (if there is any) to show it later
	    window.saved_scope = $('#scope_permission_scope_id').val();    
	    //updates the scope
		change_scope_elements( $('#scope_permission_permission_id').val() );
	};
    
});

