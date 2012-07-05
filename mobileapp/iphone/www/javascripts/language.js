/**
	Select language 
*/
function select_language()
{
	if(document.getElementById('lang1').value == 'on') {
		lang = 'en';
		window.localStorage.setItem('lang', 'en');
	} else {
		if(document.getElementById('lang2').value == 'on') {
			lang = 'es';
			window.localStorage.setItem('lang', 'es');
		}
	}
	apply_language();
	if(token) {
		show('page-home');
	} else {
		show('page-agree');
	}
}
/**
	Get translated string for a key 
	@param {string} key Key of string in language file
	@returns {string} Translated string
*/
function t(key)
{
	eval('var voc = ' + lang);
	return voc[key];
}
/**
	Apply Language
*/
function apply_language()
{
	$("#lang-form > legend").html(t('language_title'));
	document.getElementById('lang-submit').value = t('language_submit');
	
	$('#agree-button').html(t('agree_submit'));
	
	$("#profile-form > legend").html(t('profile_title'));
	$("#profile-form .input_text label").html(t('profile_code'));
	$("#login-button").html(t('profile_submit'));
	
	$(".page-home .scanstart-type p:first").html(t('home_scan_descr'));
	$(".page-home .scanstart-id .field label").html(t('home_shipment_input_title'));
	$(".page-home .scanstart-id button").html(t('home_submit'));
	
	$(".page-ship-det #header #title").html(t('shipment_title'));
	$(".page-ship-det .info-block .ib-lavel").html(t('shipment_id'));
	$(".page-ship-det legend").html(t('shipment_info'));
	$(".page-ship-det .num_of_pieces span.input-label").html(t('shipment_num_of_pieces'));
	$(".page-ship-det .total_weight span.input-label").html(t('shipment_weight'));
	$(".page-ship-det .pick_up span.input-label").html(t('shipment_pick_up'));
	$(".page-ship-det #action-select span.input-label").html(t('shipment_actions'));
	$(".page-ship-det #action-select .link-more").html(t('shipment_select'));
	$(".page-ship-det .damage span.input-label").html(t('shipment_damage'));
	$(".page-ship-det .buttons .link_complete_det").html(t('shipment_complete_details'));
	$(".page-ship-det .buttons button").html(t('shipment_submit'));
	
	$(".page-driver-act #header #title").html(t('action_title'));
	$(".page-driver-act #header .arrow-left").html(t('back'));
	$(".page-driver-act .pick_up label span").html(t('action_pick_up'));
	$(".page-driver-act .back_base label span").html(t('action_back_at_base'));
	$(".page-driver-act .route_carrier label span").html(t('action_route_carrier'));
	$(".page-driver-act .tender_carrier label span").html(t('action_tendered_carrier'));
	$(".page-driver-act .recover_carrier label span").html(t('action_recovered_carrier'));
	$(".page-driver-act .out_deliver label span").html(t('action_out'));
	$(".page-driver-act .deliver label span").html(t('action_delivery'));
	$(".page-driver-act #header .action_save").html(t('action_submit'));
	
	$(".page-damage-info .buttons button").html(t('signature_submit'));
	
	$(".page-image-box #header .arrow-left-red").html(t('back'));
	$(".page-image-box #header #title").html(t('image_box'));
	$(".page-image-box #header .button.done-butt").html(t('image_submit'));

	$(".page-album #header .button-back").html(t('back'));
	$(".page-album #header .action_save").html(t('action_submit'));
	
	$('.page-photo-preview #header .button-back').html(t('back'));
	
	$(".page-signature #header .button-back").html(t('back'));
	$(".page-signature #header #title").html(t('signature_title'));
	$(".page-signature .main-form .name label").html(t('signature_name'));
	$(".page-signature .main-form .email label").html(t('signature_email'));
	$(".page-signature .buttons button").html(t('signature_submit'));

	$(".page-image-doc #header .arrow-left-red").html(t('back'));
	$(".page-image-doc #header #title").html(t('image_pod'));
	$(".page-image-doc #header a.button.done-butt").html(t('image_submit'));
	
	$(".page-complete #header .button-back").html(t('back'));
	$(".page-complete #header #title").html(t('complete_title'));
	$(".page-complete .complete-block p").html(t('complete_descr'));
	$(".page-complete .complete-block #complete-submit").html(t('complete_submit'));
	
	$(".page-final .final-block p").html(t('final_title'));	
	$(".page-final .final-block #final-submit").html(t('final_submit'));
	
	document.getElementById('damage_info').placeholder = t('damage_description');
}