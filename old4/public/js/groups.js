//groups.js
$(document).ready(function(){
console.log("asdasd");
remote('admin/view_groups',{},'GET',displayGroups)

$("#loginCheckLoader").fadeOut(1000);
});
function displayGroups(data){
	var dataSet=[];
	$.each(data,function(k,v){
		dataSet.push([v.id,v.name,v.description,v.privacy,'<a href="'+v.thumbnail+'" target="_blank">Click to View</a>','<button class="btn btn-small btn-info" onclick="editGroup('+v.id+')">Edit</button><button class="btn btn-small btn-danger" onclick="deleteGroup('+v.id+')">Delete</button>'])
	});
	   $('#example').DataTable( {
        data: dataSet,
        columns: [
            { title: "id" },
            { title: "Name" },
            { title: "Description" },
            { title: "Privacy" },
            { title: "Image" },
             { title: "Actions" },
        ]
    } );
}
function editGroup(id){
remote('groups/'+id,{},'GET',openGroupModel)
}
function openGroupEditModel(group){
	console.log(group);
	window.editingGroup=group;
	$("#editGroup-name").val(group.name);
	$("#editGroup-description").val(group.description);
	$("#editorModel").modal("show")
}
function saveGroup(){
	remote('groups/'+window.editingGroup.id,{'name':$("#editGroup-name").val(),'description':$("#editGroup-description").val()},'PUT',function(){window.location.reload()});
}
function deleteGroup(id){
	if(confirm("Are you sure want delete this group? all his activity will be gone forever!"))
	remote('groups/'+id,{},'DELETE',function(){window.location.reload()});
}