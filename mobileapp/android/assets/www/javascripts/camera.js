/**
	Success make photo of box
*/
function boxSuccess(imageData){
	var image = document.getElementById('imagebox');
	image.style.display = 'block';
	image.src = "data:image/jpeg;base64,"+imageData;
    image.style.visibility = "visible";
	box_photos.push(imageData);
    update_album();
}
/**
	Success make photo of document
*/
function podSuccess(imageData){
	var image = document.getElementById('imagepod');
	image.style.display = 'block';
	image.src = imageData;
    image.style.visibility = "visible";
	pod_photo = imageData;
}
/**
	‘allback if could not take photo
*/
function cameraError(message) {}
/**
	Calling native interface for make photo
	@param {integer} type Type of photo (1 - Box photo, 2 - Document photo).
*/
function make_photo(type) {
	if(type == 1) {
	  navigator.camera.getPicture( boxSuccess, cameraError, {
		quality: 30,
		targetWidth:640,
		targetHeight:480,
		destinationType: navigator.camera.DestinationType.DATA_URL,
		encodingType: navigator.camera.EncodingType.JPEG
      });
	}
	if(type == 2) {
	  navigator.camera.getPicture( podSuccess, cameraError, {
		targetWidth:1024,
		targetHeight:768,
		quality: 30,
		destinationType: navigator.camera.DestinationType.FILE_URI,
		encodingType: navigator.camera.EncodingType.JPEG
      });
	}
}
/**
	Calling scan barcode plugin
*/
function scanbarcode()
{
	if(scannerrun) return;
	scannerrun = true;
	window.plugins.barcodeScanner.scan(
		function(result) {
			if (result.cancelled)
				console.log("the user cancelled the scan");
			else
				$('#id-shipment-value').val(result.text);
			scannerrun = false;
		},
		function(error) {
			alert(error);
			scannerrun = false;
		}
	);
}