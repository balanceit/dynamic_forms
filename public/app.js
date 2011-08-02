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
        }
        ],
        renderTo: 'example-grid',
        width: 540,
        height: 200,
        dockedItems: [{
            xtype: 'toolbar',
            dock: 'top',
            items: [{
                iconCls: 'icon-save',
                itemId: 'save',
                text: 'Save',
                disabled: true,
                scope: this,
                handler: this.onSave
            },
            {
                iconCls: 'icon-user-add',
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
