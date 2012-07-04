function boxSuccess(imageData){
console.log(imageData);
	var image = document.getElementById('imagebox');
	image.style.display = 'block';
	image.src = "data:image/jpeg;base64,"+imageData;
    image.style.visibility = "visible";
	
/*		mini preview photos
	if(box_photos.length >= 4) {
		var smallImages_wrap = document.getElementById('photos-small-second');
	} else {
		var smallImages_wrap = document.getElementById('photos-small');
	}
	var smallimage = new Image();
	smallimage.style.display = 'block';
	smallimage.src = "data:image/jpeg;base64,"+imageData;
	smallImages_wrap.appendChild(smallimage);
*/
	box_photos.push(imageData);
    update_album();
    console.log(box_photos.length);
}

function podSuccess(image) {
	var imag = document.getElementById("imagepod");
	pod_photo = image;
	imag.style.visibility = "visible";
	imag.src = image;
	image = null;
}

function cameraError(message) {}
function check_photos_count()
{
	if(box_photos.length > 9) {
		alert(t('error_many_photos'));
		return false;
	}
	return true;
}
function make_photo(type) {
	if(type == 1) {
//	  if(!check_photos_count()) return;
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