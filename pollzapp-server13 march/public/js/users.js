//users.js
$(document).ready(function(){
	console.log("asdasd");
remote('users',{},'GET',displayUsers)

$("#loginCheckLoader").fadeOut(1000);
});
function displayUsers(data){
	var dataSet=[];
	$.each(data,function(k,v){
		dataSet.push([v.id,v.name,v.username,v.phone,'<a href="'+v.thumbnail+'" target="_blank">Click to View</a>','<button class="btn btn-small btn-info" onclick="editUser('+v.id+')">Edit</button><button class="btn btn-small btn-danger" onclick="deleteUser('+v.id+')">Delete</button>'])
/*		$("#loadData").append('<tr>'+
  '<td>'+v.name+'</td>'+
  '<td>'+v.username+'</td>'+
  '<td>'+v.phone+'</td>'+
  '<td>'+v.created_at+'</td>'+
  '<td>'+v.updated_at+'</td>'+
  '<td><a href="'+v.thumbnail+'" target="_blank">click to view</a></td>'+
  '<td><button class="btn btn-small btn-info" onclick="editUser('+v+')">Edit</button>'+
'<button class="btn btn-small btn-danger" onclick="deleteUser('+v.id+')">Delete</button></td>'+
'</tr>')*/
	});
	   $('#example').DataTable( {
        data: dataSet,
        columns: [
            { title: "id" },
            { title: "Name" },
            { title: "Username" },
            { title: "Phone" },
            { title: "Image" },
             { title: "Actions" },
        ]
    } );
}
function editUser(id){
remote('users/'+id,{},'GET',openUserEditModel)
}
function openUserEditModel(user){
	console.log(user);
	window.editingUser=user;
	$("#editUser-name").val(user.name);
	$("#editUser-username").val(user.username);
	$("#editorModel").modal("show")
}
function saveUser(){
	remote('users/'+window.editingUser.id,{'name':$("#editUser-name").val(),'username':$("#editUser-username").val()},'PUT',function(){window.location.reload()});
}
function deleteUser(id){
	if(confirm("Are you sure want delete this user? all his activity will be gone forever!"))
	remote('users/'+id,{},'DELETE',function(){window.location.reload()});
}