import 'package:flutter_dotenv/flutter_dotenv.dart';

const maxFilesLimit = 10;
const periods = ['Per Day', 'Per Month', 'Per Year'];
const conditions = ['Luxury', 'Excellent', 'Good', 'Normal'];
final baseWebsiteUrl = dotenv.env['BASE_URL'];
const baseLink = 'assets/icons/';
const landMarks = {
  "Near Shopping Mall": '${baseLink}near shopping mall.svg',
  "Brand New": '${baseLink}new.svg',
  "Near Transportation": '${baseLink}near transportation.svg',
  "Gym": '${baseLink}gym.svg',
  "Swimming Pool": '${baseLink}pool.svg',
  "Balcony": '${baseLink}balcony.svg',
  "Furnished": '${baseLink}furnished.svg',
  "Near Tram": '${baseLink}near_tram.svg',
  "Elevator": '${baseLink}elevator.svg',
  "Parking": '${baseLink}parking.svg',
  "Security": '${baseLink}security.svg',
  "Downtown": '${baseLink}downtown.svg',
  "Air Condition": '${baseLink}air condition.svg',
  "SPA": '${baseLink}spa.svg',
  "Market": '${baseLink}market.svg',
  "Wifi": '${baseLink}wifi.svg'
};
