alert = function(message, callback, title, buttonname) {
	if(!title) title = 'InstaTrace';
	navigator.notification.alert(message,callback, title, t('ok'));
};
confirm = function(message, callback, title, buttonLabels) {
	if(!title) title = 'InstaTrace';
	navigator.notification.confirm(message, callback, title, t('ok')+','+t('cancel'));
};

var views = [
	'page-lang',
	'page-agree',
	'page-profile',
	'page-home',
	'page-ship-det',
	'page-driver-act',
	'page-damage-info',
	'page-image-box',
    'page-album',
	'page-photo-preview',
	'page-signature',
	'page-image-doc',
	'page-complete',
	'page-final'
];
function show(view)
{
	for(var i in views) {
		$("."+views[i]).fadeOut(0);
	}
	if(view) {
		active_page = view;
		if (view == "page-agree") loaded();
		if (view == "page-ship-det") load_ship_det();
		if (view == "page-signature") load_signature();
		if (view == "page-driver-act") load_actions();
		if (view == "page-album") {
			load_album();
			resize();
		}
		$("."+view).fadeIn("fast");
	}
}

function send_request(url, type, data, success, fail, async)
{
	if(async == null) async = true;
    $.ajax({
        url: url,
        type: type,
        data: data,
		async: async,
        timeout: 5000
    }).done(function(data){
        if(typeof(success) == 'function') success(data);
    }).fail(function(error){
		if(error.status == 401)
			alert(t('error_not_auth'));
		else 
			if(check_connection()) if(typeof(fail) == 'function') fail(error);
    }).complete(function(jqXHR, textStatus){
        var response = JSON.stringify(jqXHR);
        console.log("textStatus: "+ textStatus);
    });
}
function check_connection()
{
	if(navigator.network.connection.type == 'none' || 
	 navigator.network.connection.type == 'unknown') {
		alert(t('error_no_internet'));
		return false;
	}
	return true;
}
function login()
{
    var data = {
        code: $('#activation_code').val()
    };
    send_request(url+'api/activation', 'POST', data,
        function(data){
            token = data.token;
            show('page-home');
        },
        function(data){
            alert(t('error_activation'));
        }
    );
}

function get_shipment_details()
{
    var data = {
        token: token,
		shipment_id: $('#id-shipment-value').val()
    };
    send_request(url+'api/shipment','POST', data,
        function(data){
        	console.log(JSON.stringify(data));
            fill_shipment_data(data);
            show('page-ship-det');
        },
        function(data){
            alert(t('error_shipment_id'));
        }
    );
}


function fill_shipment_data(shipment){
	$('.page-ship-det .info-block .ib-value').html(shipment.hawb);
	$('#shipment-details-form .num_of_pieces .input-value').html(shipment.pieces);
	$('#shipment-details-form .total_weight .input-value').html(shipment.weight);
	$('#shipment-details-form .pick_up .input-value').html(shipment.pick_up);
	$('#shipment-details-form .destination .input-value').html(shipment.destination);
	$('.page-ship-det #shipment-details-form #action-select .link-more').html(t('shipment_select'));
	$('#shipment-details-form .damage #checbox').attr('checked', true);
}

$('#agree-button').click(function(){
	show('page-profile');
});

function signature_submit()
{
	if(!ValidateEmail()) return;
    var data = {
		token : token,
		name : $('.page-signature input#name').val(),
		email: $('.page-signature input#email').val(),
		signature: api.getSignatureImage()
	};
	send_request(url+'api/shipment/signature', 'POST', data,
        function(data){
			check_go_image_pod();
        },
        function(data){
            var obj = JSON.parse(data.responseText);
            console.log(JSON.stringify(data));
            if (typeof(obj.errors) == 'object') { 
                alert(obj.errors[0]);
            } else {
                alert(obj.errors);
            }
        }
    );
}

function shipment_submit()
{
	if(action == undefined || action == '') {
		alert(t('error_action_required'));
		return false;
	}
	if($('#shipment-details-form .damage #checbox').is(':checked')) show('page-image-box');
	else show('page-damage-info');
	getcurentposition();
}

function complete_submit()
{
   uploadPhoto();
   reset_image_box();
    var data = {token: token};
    send_request(url+'api/shipment/complete', 'POST', data,
        function(data){show('page-final');},
        function(data){
            var obj = JSON.parse(data.responseText);
            if(typeof(obj.errors) == 'object') {
                alert(obj.errors[0]);
            } else {
                alert(obj.errors);
            }
        }
    );
}

$('#final-submit').click(function(){
	show('page-home');
});

$('.icon-home').click(function(){
	show('page-home');
});
function show_driver_act()
{
	if(action == 'pick-up') 
		$('.page-driver-act .main-form #f1').attr('checked', true);
	else $('.page-driver-act .main-form #f1').attr('checked', false);
	if(action == 'back_at_base')
		$('.page-driver-act .main-form #f2').attr('checked', true);
	else $('.page-driver-act .main-form #f2').attr('checked', false);
	if(action == 'en_route_to_carrier')
		$('.page-driver-act .main-form #f3').attr('checked', true);
	else $('.page-driver-act .main-form #f3').attr('checked', false);
	if(action == 'tendered_to_carrier')
	    $('.page-driver-act .main-form #f4').attr('checked', true);
	else $('.page-driver-act .main-form #f4').attr('checked', false);
	if(action == 'recovered_from_carrier')
		$('.page-driver-act .main-form #f5').attr('checked', true);
	else $('.page-driver-act .main-form #f5').attr('checked', false);
	if(action == 'out_for_delivery')
		$('.page-driver-act .main-form #f6').attr('checked', true);
	else $('.page-driver-act .main-form #f6').attr('checked', false);
	if(action == 'delivery')
		$('.page-driver-act .main-form #f7').attr('checked', true);
	else $('.page-driver-act .main-form #f7').attr('checked', false);
	show('page-driver-act');
}
function change_driver_act()
{
	var title ='';
	if($('.page-driver-act .main-form #f1').attr('checked')) {
		title = t('action_pick_up');
		action = 'pick-up';
	}
	if($('.page-driver-act .main-form #f2').attr('checked')) {
		title= t('action_back_at_base');
		action = 'back_at_base';
	}
	if($('.page-driver-act .main-form #f3').attr('checked')) {
		title = t('action_route_carrier');
		action = 'en_route_to_carrier';
	}
	if($('.page-driver-act .main-form #f4').attr('checked')) {
		title = t('action_tendered_carrier');
		action = 'tendered_to_carrier';
	}
	if($('.page-driver-act .main-form #f5').attr('checked')) {
		title = t('action_recovered_carrier');
		action = 'recovered_from_carrier';
	}
	if($('.page-driver-act .main-form #f6').attr('checked')) {
		title = t('action_out');
		action = 'out_for_delivery';
	}
	if($('.page-driver-act .main-form #f7').attr('checked')) {
		title = t('action_delivery');
		action = 'delivery';
	}
	if(!action || action == '') {
		alert(t('error_action_submit')); 
		return;
	}
	$('.page-ship-det #shipment-details-form #action-select .link-more').html(title);
	show('page-ship-det');
}
function go_home()
{
	confirm(t('confirm_go_home'), function(ch){
	if(ch == 1) {
	  send_request(url+'api/shipment/cancel', 'POST', {token:token},
        function(data){
			show('page-home');
			var shipment = {
				shipment_id: '',
				pieces: '',
				weight: '',
				pick_up: '',
				destination: '',
				damaged: false
			};
			fill_shipment_data(shipment);
			action ='';
			$('#damage_info').val('');
			reset_image_box();
			reset_image_pod();
			reset_signature();
		},
        function(data){console.log(JSON.stringify(data));}
      );
	}},t('confirm_go_home_title')); 
}
function check_damage()
{
	if($('#shipment-details-form .damage #checbox').is(':checked')) alert('false');
	else alert('true');
	
}
var upload_params;
function prepare_params()
{
	var data = {
		token: token,
		lat: latitude,
		lon: longitude,
		damage: $('#damage_info').val()
	};
	
	if(action != undefined && action != '') data.driver_action = action;
	if($('#shipment-details-form .damage #checbox').is(':checked')) data.damaged = 0;
	else data.damaged = 1;
	
	upload_params = data;	
}
function send_shipment_info()
{
	prepare_params();
    if(box_photos.length > 0) {
        show('page-album');
    } else {

      send_request(url+'api/shipment/damage', 'POST', upload_params,
        function(data){
            console.log(data);
            check_go_signature();
            $('#damage_info').val('');
        },
        function(data){console.log(JSON.strigify(data));}
      );
    }
}

function getcurentposition()
{
	navigator.geolocation.getCurrentPosition(GeoOnSuccess, GeoOnError);
}
function GeoOnSuccess(position) {
	latitude = position.coords.latitude;
	longitude = position.coords.longitude;
}
function GeoOnError(error) {

}
function check_go_signature()
{
	if(action == 'pick-up' || action == 'delivery') {
		show('page-signature');
	} else {
		check_go_image_pod();
	}
}
function check_go_image_pod()
{
	if(action == 'delivery' || action == 'tendered_to_carrier' || action == 'recovered_from_carrier') {
		show('page-image-doc');
	} else {
		show('page-complete');
	}
}
function send_pod()
{
	var data = {
		token : token,
		type: 'pod'
	}
	if(pod_photo != undefined && pod_photo != '') {
		var options = new FileUploadOptions();
		options.fileKey="document";
		options.fileName=pod_photo.substr(pod_photo.lastIndexOf('/')+1)+".jpg";
		options.mimeType="image/jpeg";
		options.params = data;
		options.chunkedMode = false;
	
		var ft = new FileTransfer();
		ft.upload(pod_photo, url+ 'api/shipment/doc', sendpodSuccess, uploadError, options);
		pod_photo = '';
	} else {
		show('page-complete');
	}
}
function sendpodSuccess(data) {
	show('page-complete');
	reset_image_pod();
}

function next_shipment()
{
	show('page-home');
	reset_image_box();
	reset_image_pod();
	reset_signature();
	action = '';
    $('#damage_info').val('');
}
function reset_image_box() {
	box_photos = [];
	var image = document.getElementById('imagebox');
	image.src = '';
	image.style.visibility = "hidden";
	$('#photos-small img').remove();
	$('#photos-small-second img').remove();
	$('#album_wrapper div').remove();
}
function reset_image_pod() {
	pod_photo = '';
	var image = document.getElementById('imagepod');
	image.src = '';
	image.style.visibility = "hidden";
}
function reset_signature() {
	api.clearCanvas();
	$('.page-signature input#name').val('');
	$('.page-signature input#email').val('');
}
	
function uploadSuccess(data) {

}
function uploadError(error) {
    console.log(JSON.stringify(error));
	alert("Error upload photo.\n Please try again later.");
}
function clear_photos_array()
{
	var result = [];
	for(var i =0; i< box_photos.length; i++) {
		if(box_photos[i] == null) continue;
		result.push(box_photos[i]);
	}
	box_photos = result;
}
function uploadPhoto() 
{
	clear_photos_array();
    var data = {
		token: token,
		lat: latitude,
		lon: longitude,
		damage: $('#damage_info').val(),
        photo: box_photos
    };
	
	if(action != undefined && action != '') data.driver_action = action;
	if($('#shipment-details-form .damage #checbox').is(':checked')) data.damaged = 0;
	else data.damaged = 1;

    send_request(url+'api/shipment/damage', 'POST', data,
        function(data){console.log(JSON.stringify(data));},
        function(data){console.log(JSON.stringify(data));},
		false
    );
}

function damageinfo_submit()
{
	show('page-image-box');
}

function go_back()
{
	if(action == 'delivery' || action == 'pick-up') {
		show('page-signature');
	} else {
		show('page-album');
	}
}

$('#photos-small img').live('click', function(){
	var image = document.getElementById('imagebox');
	image.src = this.src;
});
$('#photos-small-second img').live('click', function(){
	var image = document.getElementById('imagebox');
	image.src = this.src;
});

function deletefile(path)
{
    window.resolveLocalFileSystemURI(path, getfilesuccess, function() {alert('error search file')});
}

function getfilesuccess(fileEntry)
{
    fileEntry.remove(function(){}, function(){});
}

function update_album() 
{
    $('#album_wrapper > div').remove();
    for(var i in box_photos) {
    if(box_photos[i] == undefined || box_photos[i] == null) continue;
        var div = document.createElement("div"); 
        div.className = 'photo';
		div.style.display = 'block';
		div.style.height = '80px';
		div.style.width = '80px';
    
        var img = new Image();
        img.src = "data:image/jpeg;base64,"+box_photos[i];
        img.style.width = '80px';
        img.style.height = '80px';
        img.id = "photo_"+i;
		img.className = "photo_in_album";
        console.log(img.id);

        var del = document.createElement("a");
        del.className = "del";
        del.id = i;
		del.href = "#";
    
        div.appendChild(img);
        div.appendChild(del);
        var album = document.getElementById('album_wrapper');
		album.appendChild(div);
    }
}
function album_submit()
{
   check_go_signature();
}
$('.photo_in_album').live('click', function(){
	var image = document.getElementById('photo-preview');
	image.src = this.src;
	show('page-photo-preview');
	
});
$('#album_wrapper a.del').live('click', function(){
    var self = this;
	console.log("photos count1: "+box_photos.length);
    confirm(t("delete_confirm"),function(ch){
        if(ch == 1) {
            $("#photo_"+self.id).remove();
            delete box_photos[self.id];
            $(self).parent().remove();
        }
    });
    console.log("photos count2: "+box_photos.length);
});

var orientarion;
function AccelerationSuccess(acceleration)
{
    console.log("x: "+acceleration.x+ " y: "+acceleration.y);
    console.log("z: "+acceleration.z);
    var canvas = document.getElementById('canvas');
    var context = canvas.getContext("2d");
    if(Math.abs(acceleration.x) > Math.abs(acceleration.y) +1 && Math.abs(acceleration.z) <9) {
        if(orientation == 'portrait' || orientation == 'undefined') {
            orientation = 'landscape';
        
        } else {
            orientation = 'landscape';
        }
    } else {
        //portrait
        if(orientation == 'undefined') {
            orientation = 'portrait';
        }
        if(orientation == 'landscape') {
            orientation = 'portrait';
            console.log(canvas.style.width);
        }
    }
}
function resize(){
	if(active_page == 'page-signature') {
		canvas = document.getElementById("canvas");
		if (canvas.width < window.innerWidth || canvas.width > window.innerWidth) {
			canvas.width = window.innerWidth;
		}
		api.clearCanvas();
	}
	if(active_page == 'page-photo-preview') {
		if(window.innerWidth > window.innerHeight) {
			$('#photo-preview').css({width: '75%', height: '56%', padding: '0 0 0 12%'});
		} else {
			$('#photo-preview').css({width: '100%', height: '90%', padding: '0'});
		}
	}
	if(active_page == 'page-album') {
		if(window.innerWidth > window.innerHeight) {
			$('#photo-preview').css({width: '75%', height: '140%', padding: '0 0 0 12%'});
		} else {
			$('#photo-preview').css({width: '100%', height: '90%', padding: '0'});
		}
	}
}

function echeck(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		
		if (str.indexOf(at)==-1) return false;
		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr) return false;
		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr) return false;
		if (str.indexOf(at,(lat+1))!=-1) return false;
		if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot) return false;
		if (str.indexOf(dot,(lat+2))==-1) return false;
		if (str.indexOf(" ")!=-1) return false;

 		return true;
	}

function ValidateEmail(){
	var email = document.getElementById("email");
	if ((email.value != null) && (email.value != "") && (email.value != undefined)) {
		if (echeck(email.value) == false) {
			alert(t("error_invalid_email"));
			email.focus();
			return false;
		}
	}
	return true;
 }
 