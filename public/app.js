Ext.require([
'Ext.data.*',
'Ext.grid.*'
]);




function listProjects() {
    Ext.define('Project', {
        extend: 'Ext.data.Model',
        fields: ['id', 'name']
    });

    // create the Data Store
    var store = Ext.create('Ext.data.Store', {
        model: 'Project',
        autoload: true,
        proxy: {
            // load using HTTP
            type: 'ajax',
            url: 'projects.json',
            // the return will be JSON, so lets set up a reader
            reader: {
                type: 'json',
                root: 'projects',
                record: 'project',
                totalRecords: 'total',
                successProperty: 'success'
            }
        }
    });

    // create the grid
    var grid = new Ext.grid.GridPanel({
        store: store,
        columns: [
        {
            text: "id",
            flex: 1,
            dataIndex: 'id',
            sortable: true
        },
        {
            text: "Name",
            width: 180,
            dataIndex: 'name',
            sortable: true
        },
        {
            xtype: 'actioncolumn',
            width: 50,
            items: [{
                icon   : '/images/delete.gif',  // Use a URL in the icon config
                tooltip: 'Delete',
                handler: function(grid, rowIndex, colIndex) {
                    var rec = store.getAt(rowIndex);
					var delRequest = Ext.Ajax.request({
					    url: '/projects/' + rec.get('id'),
					    params: {
					        _method: 'delete'
					    },
						method: 'post',
					    success: function(response){
					        var text = response.responseText;
					        console.log(text);
							store.load();
					    }
					});	
					delRequest.request();
                }
            },
			{
                icon   : '/images/book.png',  // Use a URL in the icon config
                tooltip: 'Edit',
                handler: function(grid, rowIndex, colIndex) {
                    var rec = store.getAt(rowIndex);
                    window.location.href = '/projects/' + rec.get('id');
                }
            }]
        }
        ],
        renderTo: 'example-grid',
        width: 540,
        height: 200,
        dockedItems: [{
            xtype: 'toolbar',
            dock: 'top',
            items: [
            {
                icon: '/images/add.gif',
                text: 'Create',
                scope: this,
                handler: addProject
            }
            ]
        }]
    });

	function addProject() {
		window.location.href = '/projects/add';
	}
    store.load();
};
