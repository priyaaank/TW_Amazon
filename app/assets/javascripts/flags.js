$(document).ready(function() {

	// --- language dropdown --- //

	// turn select into dl
	createDropDown();

	var $dropTrigger = $(".dropdown dt a");
	var $languageList = $(".dropdown dd ul");

	// open and close list when button is clicked
	$dropTrigger.toggle(function() {
		$languageList.slideDown(200);
		$dropTrigger.addClass("active");
	}, function() {
		$languageList.slideUp(200);
		$(this).removeAttr("class");
	});

	// close list when anywhere else on the screen is clicked
	$(document).bind('click', function(e) {
		var $clicked = $(e.target);
		if (! $clicked.parents().hasClass("dropdown"))
			$languageList.slideUp(200);
			$dropTrigger.removeAttr("class");
	});

	// when a language is clicked, make the selection and then hide the list
	$(".dropdown dd ul li a").click(function() {
		var clickedValue = $(this).parent().attr("class");
		var clickedTitle = $(this).find("em").html();
		$("#target dt").removeClass().addClass(clickedValue);
		$("#target dt em").html(clickedTitle);
		$languageList.hide();
		$dropTrigger.removeAttr("class");
		var secondCombo = document.getElementById ("user_region");
        	secondCombo.value = clickedTitle;
        	document.forms[0].submit();

	});
});

	// actual function to transform select to definition list
	function createDropDown(){
		var $form = $("span#countryselect form");
		$form.hide();
		var source = $("#user_region");
		source.removeAttr("autocomplete");
		var selected = source.find("option:selected");
		var options = $("option", source);
		$("#countryselect").append('<dl id="target" class="dropdown"></dl>')
		$("#target").append('<dt class="' + selected.text() + '"><a href="#"><span class="flag"></span><em>' + selected.text() + '</em></a></dt>')
		$("#target").append('<dd><ul></ul></dd>')
		options.each(function(){
			$("#target dd ul").append('<li class="' + $(this).text() + '"><a href="#"><span class="flag"></span><em>' + $(this).text() + '</em></li>');
			});

	}
