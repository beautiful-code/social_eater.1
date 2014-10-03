var __geoLoc__ = {};

var GeoLocation = {
  result: function() {
    return __geoLoc__ ;
  }
};

GeoLocation.init = function() {
  navigator.geolocation.getCurrentPosition(
    function(position) {
      __geoLoc__.position = position;
    },
    function(error) {
      __geoLoc__.error = error;
    },
    {
      enableHighAccuracy: true,
      maximumAge: 0
    }
  );
}

var ComputeLocation = {
  init: function(geocoder, geoInfo, localities,container) {
    this.geocoder = geocoder;
    this.geoInfo = geoInfo;
    this.localities = localities;
  },
  results: function() {
    return __geoLoc__.results;
  }
}

ComputeLocation.start = function() {
  if(this.geoInfo.position) {
    this.process(
      this.geoInfo.position.coords.latitude,
      this.geoInfo.position.coords.longitude
    );
  } else {
    ComputeLocation.manualLocation(
      'GPS is disabled on your device. or Please select the location.'
    );
  }
};

ComputeLocation.process = function(lat,lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  this.geocoder.geocode({'location': latlng}, function(results,status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[1]) {
        $.cookie('_lat',parseFloat(lat).toFixed(6));
        $.cookie('_lon',parseFloat(lng).toFixed(6));
        __geoLoc__.results =  results;
      } else {
        ComputeLocation.manualLocation();
      }
    } else {
      ComputeLocation.manualLocation();
    }
  });
};

ComputeLocation.manualLocation = function(msg) {
  var m = msg? msg : 'Select your Location';

  $('#selectLocation .modal-title').html(m);

  $('#selectLocation').modal({
    backdrop: 'static',
    keyboard: false
  });
};

ComputeLocation.matchLocality = function(addr) {
  var localities = this.localities;
  var address = $.map(addr.split(','), $.trim);
  var curr_locality = null;
  address.filter(function(n) {
    return $.each(localities,function(index,locality){
      if (locality.area_name == n ){
        curr_locality = locality;
        return true;
      }
    });
  });

  if (curr_locality) {
    return curr_locality;
  } else {
    this.manualLocation(
      'Unable to locate the correct address. Please select the location.'
    );
  }
};

ComputeLocation.updateAddress = function(locality) {
  $('.btn-loc span').html(locality.area_name);
  $('.center-block p').html('Searching for yummy food');
  $('.results .result span').html('"'+locality.area_name+'"');
  $.cookie('_locality_id',locality.id);
  $.cookie('_locality_name',locality.area_name);
  var date = new Date();
  $.cookie('_updated_at',date.getTime());
  this.updatePlaces('','');
  this.showContent();
};

ComputeLocation.updatePlaces = function(item_name,cuisine_id) {
  var url = item_name? '/searches/items_places' : '/searches/places'
  $.get(
    url,
    {
      locality_id: $.cookie('_locality_id'),
      lat: $.cookie('_lat'),
      lon: $.cookie('_lon'),
      radius: 5,
      item_name: item_name,
      cuisine_id: cuisine_id
    },
    function(data) {
      $('#places .content').html(data);
    }
  );
};

ComputeLocation.setLocation = function(locality) {
  $.cookie('_lat','');
  $.cookie('_lon','');
  this.updateAddress(locality);
};

ComputeLocation.showContent = function() {
  this.toggleCheck('.filter');
  $('.first-time-user').hide();
};

ComputeLocation.toggleCheck = function(element) {
  var state = $(element).css('display');
  if (state == 'block') {
  } else {
    $(element).toggle();
  }
};

