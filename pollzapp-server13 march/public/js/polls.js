//polls.js
$(document).ready(function(){
console.log("asdasd");
remote('polls',{},'GET',displayPolls)

$("#loginCheckLoader").fadeOut(1000);
});
function displayPolls(data){
	var dataSet=[];
	$.each(data,function(k,v){
		dataSet.push([v.id,v.title,v.question,v.duration,'<a href="'+v.thumbnail+'" target="_blank">Click to View</a>','<button class="btn btn-small btn-info" onclick="editGroup('+v.id+')">Edit</button><button class="btn btn-small btn-danger" onclick="deleteGroup('+v.id+')">Delete</button>'])
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
function editPolls(id){
remote('polls/'+id,{},'GET',openPollModel)
}
function openPollEditModel(group){
	console.log(poll);
	window.editingPoll=poll;
	$("#editPoll-name").val(poll.name);
	$("#editPoll-description").val(poll.description);
	$("#editorModel").modal("show")
}
function saveGroup(){
	remote('polls/'+window.editingGroup.id,{'name':$("#editGroup-name").val(),'description':$("#editGroup-description").val()},'PUT',function(){window.location.reload()});
}
function deleteGroup(id){
	if(confirm("Are you sure want delete this group? all his activity will be gone forever!"))
	remote('groups/'+id,{},'DELETE',function(){window.location.reload()});
}