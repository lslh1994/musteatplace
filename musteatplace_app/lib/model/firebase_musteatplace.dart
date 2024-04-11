/*--------------------------------------
	 * Description : firebase model
	 * Author 	   : LS
	 * Date 	     : 2024.04.10
	 * Details	
	 *-------------------------------------- 
	 */

class FireBaseMusteatplace {
  String? id;
  String name;
  String phone;
  double lat;
  double long;
  String? image;
  String estimate;
  String initdate;

  FireBaseMusteatplace ({
    this.id,
    required this.name,
    required this.phone,
    required this.lat,
    required this.long,
    required this.image,
    required this.estimate,
    required this.initdate,
  });

}