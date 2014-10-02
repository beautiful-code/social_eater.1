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
      console.log(
        'This browser does not support HTML5 navigator API :( !'
      );
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


EATER.mainView = function(container,localities,options) {
  var self = this;

  this.container = container;
  this.localities = localities;
  this.options = options;

  this.geoInfo = new EATER.GeoLocation();
  this.geoCoder = new google.maps.Geocoder();

  this.setLatLonCookie = function(latitude, longitude) {
    $.cookie('_lat',latitude);
    $.cookie('_lon',longitude);
  };

  this.computeLocation = function (latitude,longitude) {
    var latlong = new google.maps.LatLng(latitude,longitude);

    this.geoCoder.geocode(
      {
        'location': latlong
      },
      function(results,status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (results[1]) {
            this.setLatLonCookie(latitude,longitude);
            this.geoInfo.address = results;
          } else {
            this.manualLocation();
          }
        } else {
          this.manualLocation();
        }
    });

  };

  this.manualLocation = function(msg) {
    var msg = msg? msg : 'Select your Location';

    self.container.find('#selectLocation .modal-title').html(msg);

    self.container.find('#selectLocation').modal({
      backdrop: 'static',
      keyboard: false
    });
  };

  this.matchLocality = function() {
    var address = $.map(
      self.geoInfo.address[1].formatted_address,
      $.trim
    );
    var current_locality = null;

    address.filter(function(area_name) {
      return $.each(self.localities,function (index,locality) {
        if(locality.area_name == area_name) {
          current_locality = locality;
          return true;
        } else {
          return false;
        }
      });
    });

    if(current_locality) {
      return current_locality;
    } else {
      this.manualLocation(
        'Unable to locate the correct address.' +
        'Please select the location.'
      );
    }
  };

};
