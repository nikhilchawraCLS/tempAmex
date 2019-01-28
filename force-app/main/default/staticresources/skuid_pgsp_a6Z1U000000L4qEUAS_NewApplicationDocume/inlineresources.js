(function(skuid){
skuid.snippet.register('OpenPreviewDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var attachmentRow = skuid.model.getModel('NewAttachmentModel').getFirstRow();
var title = attachmentRow.Name;
var iframeUrl = '/apex/genesisExtn__previewDocCategory?id=' + attachmentRow.Id +'&isdtp=vw';
		
openTopLevelDialog({
    title: 'Document Viewer-'+ title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('AddAttachmentsModal',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];
var title = 'Add Application Documents to ' + selectDocument.clcommon__Category_Name__c; 
var skuidPage = 'ApplicationAttachmentList';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + selectDocument.Id;
var prefixHtml = '<div><p>Select the following application documents that have not been added to any application document category and add them to <strong>' + selectDocument.clcommon__Category_Name__c + '</strong>.</p></div>';
openTopLevelDialog({
	title: title,
	iframeUrl: iframeUrl,
	prefixHtml: prefixHtml
});
});
skuid.snippet.register('DeleteAttachment',function(args) {var params = arguments[0],
	$ = skuid.$;
var catAssociation = skuid.model.getModel('CatDocAssociation').data[0];
var documentId = catAssociation.clcommon__Attachment_Id__c;
var parentId = catAssociation.clcommon__Document_Category__c;
var documentName = catAssociation.Name;


var title = 'Delete ' + documentName + '?';
var message = '<p>Are you sure you want to Delete this Application Document'
			+ ', <strong>\'' + documentName + '\'</strong>?</p>';
var cancelText = 'No, do not Delete anything.';
var okText = 'Yes, Delete Application Document'
			+ ' \'' + documentName + '\'';

var okAction = {
	func: 'generateDeleteDocumentMessage',
	parameters: [documentId, parentId]
};

openTopLevelConfirmation({
	title: title,
	message: message,
	cancelText: cancelText,
	okText: okText,
	okAction: okAction
});
});
skuid.snippet.register('DeleteDocumentCategory',function(args) {var params = arguments[0],
	$ = skuid.$;
var selectDocument = skuid.model.getModel('DocumentCategoryDetails').data[0];
var documentCategoryId = selectDocument.Id;	
var documentCategoryName = selectDocument.clcommon__Category_Name__c

var title = 'Delete ' + documentCategoryName + '?';
var message = '<p>Are you sure you want to Delete this Application Document Category'
			+ ', <strong>\'' + documentCategoryName + '\'</strong>?</p>';
var cancelText = 'No, do not Delete anything.';
var okText = 'Yes, Delete Application Document Category'
			+ ' \'' + documentCategoryName + '\'';

var okAction = {
	func: 'generateDeleteDocumentCategoryMessage',
	parameters: [documentCategoryId]
};

openTopLevelConfirmation({
	title: title,
	message: message,
	cancelText: cancelText,
	okText: okText,
	okAction: okAction
});
});
}(window.skuid));