<%@ include file="/init.jsp" %>

<div class="container-fluid gsearch-container">

	<div class="input-group">
	
		<input 
			autofocus 
			class="form-control input-lg textinput" 
			id="<portlet:namespace />MiniSearchField" 
			name="<portlet:namespace />MiniSearchField" 
			maxlength="100" 
			placeholder="<%=LanguageUtil.get(request, "keywords") %>" 
			required="required" 
			type="text" 
			value="" 
		/>
			
		<span class="input-group-btn">
			<button 
				class="btn btn-secondary" 
				id="<portlet:namespace />MiniSearchButton" 
				type="button">
				<svg class="lexicon-icon">
			        <use xlink:href="/o/classic-theme/images/lexicon/icons.svg#search" />
				</svg>
			</button>
		</span>
	</div>
		
	<%-- Hidden element for anchoring messages tooltip  --%>
	
	<div class="message-wrapper" data-title="" id="<portlet:namespace />MiniSearchFieldMessage"></div>
</div>

<aui:script>

	Liferay.Portlet.ready(
	
	    function(portletId, node) {
			<portlet:namespace />initAutocomplete();
			
			$('#<portlet:namespace />MiniSearchField').on('keyup', function(event) {
				<portlet:namespace />handleKeyUp(event);
			});	

			$('#<portlet:namespace />MiniSearchButton').on('click', function(event) {
				<portlet:namespace />doSearch();
			});	
	    }
	);

	/**
	 * Execute search
	 */
	function <portlet:namespace />doSearch() {

		let q = $('#<portlet:namespace />MiniSearchField').val();
		
		if (q.length < <%=queryMinLength%>) {
			<portlet:namespace />showMessage(Liferay.Language.get('min-character-count-is') + '<%=queryMinLength %>');
			return false;
		}
		
		let url = '<%=searchPageURL %>?q=' + q;

		window.location.replace(url);
	}
	
	/**
	 * Handle keyup  events.
	 */
	function <portlet:namespace />handleKeyUp(event) {

        let keycode = (event.keyCode ? event.keyCode : event.which);
        
        if(keycode === 13){
        	<portlet:namespace />doSearch();
	    }
	}
	
	/**
	 * Init autocomplete / suggester.
	 */
	 function <portlet:namespace />initAutocomplete() {

		let searchFieldElement = $('#<portlet:namespace />MiniSearchField');
		 		
		Liferay.Loader.require('devbridgeAutocomplete', function(devbridgeAutocomplete) {

			$(searchFieldElement).devbridgeAutocomplete({
			
				dataType: 'json',
				deferRequestBy: <%=autoCompleteRequestDelay %>,
				minChars: <%=queryMinLength %>,
				noCache: false,
			    onSelect: function (suggestion) {
			    	<portlet:namespace />doSearch();
			    },
				paramName: 'q',
				serviceUrl: '<%=suggestionsURL %>',
				transformResult: function(response) {
	
					if (response) {
					    return {
		    				suggestions: $.map(response, function(item) {
					    		return {
					    			value: item, 
					    			data: item
					    		};
					        })
					    };
	    			} else {
	    				return {
	    					suggestions: []
	    				}
		    		}
				},
				triggerSelectOnValidInput: false
			});
		});
	}	
	
	/**
	 * Show message
	 */
	function <portlet:namespace />showMessage(title) {
		
		let elementId = '<portlet:namespace />MiniSearchFieldMessage';
		
		$('#' + elementId).tooltip({title: title}).tooltip('show');
		
		// Setting delay doesn't work on manual show
		
		setTimeout(function(){
			$('#' + elementId).tooltip('hide');
		}, 2000);		
	}	
	
</aui:script>
