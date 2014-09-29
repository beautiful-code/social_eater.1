var EATER = function($){
  return {};
}(jQuery);

EATER.GeoLocation = function() {

  this.init = function() {
    if(navigator) {
      navigator.geolocation.getCurrentPosition(
        this.geoSuccess.bind(this),
        this.geoError.bind(this),
        {
          enableHighAccuracy: true,
          maximumAge: 0
        }
      );
    } else {
      console.log('This browser does not support HTML5 navigator API :( !');
    }
  };

  this.geoSuccess = function(position) {
    this.results = {
      position: position,
      success: true
    };
  };

  this.geoError = function(error) {
    this.results = {
      error: error,
      success: false
    };
  };

  this.init();

};


EATER.GeoView = function(container,options) {
  var self = this;

  this.container = container;
  this.options = options;

  this.geoLocation = new EATER.GeoLocation();


};
