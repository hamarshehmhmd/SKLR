import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:sklr/Home/home.dart';
import 'package:sklr/Auth/phoneVerify.dart';

class Country {
  final String code;
  final String name;
  final String prefix;

  Country({required this.code, required this.name, required this.prefix});
}

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  PhoneState createState() => PhoneState();
}

class PhoneState extends State<PhoneNumber> {
  final List<Country> countries = [
    Country(code: 'AF', name: 'Afghanistan', prefix: '93'),
    Country(code: 'AL', name: 'Albania', prefix: '355'),
    Country(code: 'DZ', name: 'Algeria', prefix: '213'),
    Country(code: 'AS', name: 'American Samoa', prefix: '1-684'),
    Country(code: 'AD', name: 'Andorra', prefix: '376'),
    Country(code: 'AO', name: 'Angola', prefix: '244'),
    Country(code: 'AI', name: 'Anguilla', prefix: '1-264'),
    Country(code: 'AG', name: 'Antigua and Barbuda', prefix: '1-268'),
    Country(code: 'AR', name: 'Argentina', prefix: '54'),
    Country(code: 'AM', name: 'Armenia', prefix: '374'),
    Country(code: 'AW', name: 'Aruba', prefix: '297'),
    Country(code: 'AU', name: 'Australia', prefix: '61'),
    Country(code: 'AT', name: 'Austria', prefix: '43'),
    Country(code: 'AZ', name: 'Azerbaijan', prefix: '994'),
    Country(code: 'BS', name: 'Bahamas', prefix: '1-242'),
    Country(code: 'BH', name: 'Bahrain', prefix: '973'),
    Country(code: 'BD', name: 'Bangladesh', prefix: '880'),
    Country(code: 'BB', name: 'Barbados', prefix: '1-246'),
    Country(code: 'BY', name: 'Belarus', prefix: '375'),
    Country(code: 'BE', name: 'Belgium', prefix: '32'),
    Country(code: 'BZ', name: 'Belize', prefix: '501'),
    Country(code: 'BJ', name: 'Benin', prefix: '229'),
    Country(code: 'BM', name: 'Bermuda', prefix: '1-441'),
    Country(code: 'BT', name: 'Bhutan', prefix: '975'),
    Country(code: 'BO', name: 'Bolivia', prefix: '591'),
    Country(code: 'BA', name: 'Bosnia and Herzegovina', prefix: '387'),
    Country(code: 'BW', name: 'Botswana', prefix: '267'),
    Country(code: 'BR', name: 'Brazil', prefix: '55'),
    Country(code: 'BN', name: 'Brunei Darussalam', prefix: '673'),
    Country(code: 'BG', name: 'Bulgaria', prefix: '359'),
    Country(code: 'BF', name: 'Burkina Faso', prefix: '226'),
    Country(code: 'BI', name: 'Burundi', prefix: '257'),
    Country(code: 'KH', name: 'Cambodia', prefix: '855'),
    Country(code: 'CM', name: 'Cameroon', prefix: '237'),
    Country(code: 'CA', name: 'Canada', prefix: '1'),
    Country(code: 'CV', name: 'Cape Verde', prefix: '238'),
    Country(code: 'KY', name: 'Cayman Islands', prefix: '1-345'),
    Country(code: 'CF', name: 'Central African Republic', prefix: '236'),
    Country(code: 'TD', name: 'Chad', prefix: '235'),
    Country(code: 'CL', name: 'Chile', prefix: '56'),
    Country(code: 'CN', name: 'China', prefix: '86'),
    Country(code: 'CO', name: 'Colombia', prefix: '57'),
    Country(code: 'KM', name: 'Comoros', prefix: '269'),
    Country(code: 'CG', name: 'Congo (Congo-Brazzaville)', prefix: '242'),
    Country(code: 'CD', name: 'Congo (Congo-Kinshasa)', prefix: '243'),
    Country(code: 'CR', name: 'Costa Rica', prefix: '506'),
    Country(code: 'CI', name: 'Côte d\'Ivoire', prefix: '225'),
    Country(code: 'HR', name: 'Croatia', prefix: '385'),
    Country(code: 'CU', name: 'Cuba', prefix: '53'),
    Country(code: 'CY', name: 'Cyprus', prefix: '357'),
    Country(code: 'CZ', name: 'Czechia (Czech Republic)', prefix: '420'),
    Country(code: 'DK', name: 'Denmark', prefix: '45'),
    Country(code: 'DJ', name: 'Djibouti', prefix: '253'),
    Country(code: 'DM', name: 'Dominica', prefix: '1-767'),
    Country(code: 'DO', name: 'Dominican Republic', prefix: '1-809'),
    Country(code: 'EC', name: 'Ecuador', prefix: '593'),
    Country(code: 'EG', name: 'Egypt', prefix: '20'),
    Country(code: 'SV', name: 'El Salvador', prefix: '503'),
    Country(code: 'GQ', name: 'Equatorial Guinea', prefix: '240'),
    Country(code: 'ER', name: 'Eritrea', prefix: '291'),
    Country(code: 'EE', name: 'Estonia', prefix: '372'),
    Country(code: 'SZ', name: 'Eswatini', prefix: '268'),
    Country(code: 'ET', name: 'Ethiopia', prefix: '251'),
    Country(code: 'FJ', name: 'Fiji', prefix: '679'),
    Country(code: 'FI', name: 'Finland', prefix: '358'),
    Country(code: 'FR', name: 'France', prefix: '33'),
    Country(code: 'GF', name: 'French Guiana', prefix: '594'),
    Country(code: 'PF', name: 'French Polynesia', prefix: '689'),
    Country(code: 'GA', name: 'Gabon', prefix: '241'),
    Country(code: 'GM', name: 'Gambia', prefix: '220'),
    Country(code: 'GE', name: 'Georgia', prefix: '995'),
    Country(code: 'DE', name: 'Germany', prefix: '49'),
    Country(code: 'GH', name: 'Ghana', prefix: '233'),
    Country(code: 'GI', name: 'Gibraltar', prefix: '350'),
    Country(code: 'GR', name: 'Greece', prefix: '30'),
    Country(code: 'GL', name: 'Greenland', prefix: '299'),
    Country(code: 'GD', name: 'Grenada', prefix: '1-473'),
    Country(code: 'GP', name: 'Guadeloupe', prefix: '590'),
    Country(code: 'GU', name: 'Guam', prefix: '1-671'),
    Country(code: 'GT', name: 'Guatemala', prefix: '502'),
    Country(code: 'GG', name: 'Guernsey', prefix: '44-1481'),
    Country(code: 'GN', name: 'Guinea', prefix: '224'),
    Country(code: 'GW', name: 'Guinea-Bissau', prefix: '245'),
    Country(code: 'GY', name: 'Guyana', prefix: '592'),
    Country(code: 'HT', name: 'Haiti', prefix: '509'),
    Country(code: 'HN', name: 'Honduras', prefix: '504'),
    Country(code: 'HK', name: 'Hong Kong', prefix: '852'),
    Country(code: 'HU', name: 'Hungary', prefix: '36'),
    Country(code: 'IS', name: 'Iceland', prefix: '354'),
    Country(code: 'IN', name: 'India', prefix: '91'),
    Country(code: 'ID', name: 'Indonesia', prefix: '62'),
    Country(code: 'IR', name: 'Iran', prefix: '98'),
    Country(code: 'IQ', name: 'Iraq', prefix: '964'),
    Country(code: 'IE', name: 'Ireland', prefix: '353'),
    Country(code: 'IL', name: 'Israel', prefix: '972'),
    Country(code: 'IT', name: 'Italy', prefix: '39'),
    Country(code: 'JM', name: 'Jamaica', prefix: '1-876'),
    Country(code: 'JP', name: 'Japan', prefix: '81'),
    Country(code: 'JE', name: 'Jersey', prefix: '44-1534'),
    Country(code: 'JO', name: 'Jordan', prefix: '962'),
    Country(code: 'KZ', name: 'Kazakhstan', prefix: '7'),
    Country(code: 'KE', name: 'Kenya', prefix: '254'),
    Country(code: 'KI', name: 'Kiribati', prefix: '686'),
    Country(code: 'KW', name: 'Kuwait', prefix: '965'),
    Country(code: 'KG', name: 'Kyrgyzstan', prefix: '996'),
    Country(code: 'LA', name: 'Laos', prefix: '856'),
    Country(code: 'LV', name: 'Latvia', prefix: '371'),
    Country(code: 'LB', name: 'Lebanon', prefix: '961'),
    Country(code: 'LS', name: 'Lesotho', prefix: '266'),
    Country(code: 'LR', name: 'Liberia', prefix: '231'),
    Country(code: 'LY', name: 'Libya', prefix: '218'),
    Country(code: 'LI', name: 'Liechtenstein', prefix: '423'),
    Country(code: 'LT', name: 'Lithuania', prefix: '370'),
    Country(code: 'LU', name: 'Luxembourg', prefix: '352'),
    Country(code: 'MO', name: 'Macao', prefix: '853'),
    Country(code: 'MK', name: 'North Macedonia', prefix: '389'),
    Country(code: 'MG', name: 'Madagascar', prefix: '261'),
    Country(code: 'MW', name: 'Malawi', prefix: '265'),
    Country(code: 'MY', name: 'Malaysia', prefix: '60'),
    Country(code: 'MV', name: 'Maldives', prefix: '960'),
    Country(code: 'ML', name: 'Mali', prefix: '223'),
    Country(code: 'MT', name: 'Malta', prefix: '356'),
    Country(code: 'MH', name: 'Marshall Islands', prefix: '692'),
    Country(code: 'MQ', name: 'Martinique', prefix: '596'),
    Country(code: 'MR', name: 'Mauritania', prefix: '222'),
    Country(code: 'MU', name: 'Mauritius', prefix: '230'),
    Country(code: 'YT', name: 'Mayotte', prefix: '262'),
    Country(code: 'MX', name: 'Mexico', prefix: '52'),
    Country(code: 'FM', name: 'Micronesia', prefix: '691'),
    Country(code: 'MD', name: 'Moldova', prefix: '373'),
    Country(code: 'MC', name: 'Monaco', prefix: '377'),
    Country(code: 'MN', name: 'Mongolia', prefix: '976'),
    Country(code: 'ME', name: 'Montenegro', prefix: '382'),
    Country(code: 'MS', name: 'Montserrat', prefix: '1-664'),
    Country(code: 'MA', name: 'Morocco', prefix: '212'),
    Country(code: 'MZ', name: 'Mozambique', prefix: '258'),
    Country(code: 'MM', name: 'Myanmar (Burma)', prefix: '95'),
    Country(code: 'NA', name: 'Namibia', prefix: '264'),
    Country(code: 'NR', name: 'Nauru', prefix: '674'),
    Country(code: 'NP', name: 'Nepal', prefix: '977'),
    Country(code: 'NL', name: 'Netherlands', prefix: '31'),
    Country(code: 'NC', name: 'New Caledonia', prefix: '687'),
    Country(code: 'NZ', name: 'New Zealand', prefix: '64'),
    Country(code: 'NI', name: 'Nicaragua', prefix: '505'),
    Country(code: 'NE', name: 'Niger', prefix: '227'),
    Country(code: 'NG', name: 'Nigeria', prefix: '234'),
    Country(code: 'NU', name: 'Niue', prefix: '683'),
    Country(code: 'NF', name: 'Norfolk Island', prefix: '672'),
    Country(code: 'MP', name: 'Northern Mariana Islands', prefix: '1-670'),
    Country(code: 'NO', name: 'Norway', prefix: '47'),
    Country(code: 'OM', name: 'Oman', prefix: '968'),
    Country(code: 'PK', name: 'Pakistan', prefix: '92'),
    Country(code: 'PW', name: 'Palau', prefix: '680'),
    Country(code: 'PA', name: 'Panama', prefix: '507'),
    Country(code: 'PG', name: 'Papua New Guinea', prefix: '675'),
    Country(code: 'PY', name: 'Paraguay', prefix: '595'),
    Country(code: 'PE', name: 'Peru', prefix: '51'),
    Country(code: 'PH', name: 'Philippines', prefix: '63'),
    Country(code: 'PL', name: 'Poland', prefix: '48'),
    Country(code: 'PT', name: 'Portugal', prefix: '351'),
    Country(code: 'PR', name: 'Puerto Rico', prefix: '1-787'),
    Country(code: 'QA', name: 'Qatar', prefix: '974'),
    Country(code: 'RO', name: 'Romania', prefix: '40'),
    Country(code: 'RU', name: 'Russia', prefix: '7'),
    Country(code: 'RW', name: 'Rwanda', prefix: '250'),
    Country(code: 'RE', name: 'Réunion', prefix: '262'),
    Country(code: 'BL', name: 'Saint Barthélemy', prefix: '590'),
    Country(code: 'SH', name: 'Saint Helena', prefix: '290'),
    Country(code: 'KN', name: 'Saint Kitts and Nevis', prefix: '1-869'),
    Country(code: 'LC', name: 'Saint Lucia', prefix: '1-758'),
    Country(code: 'MF', name: 'Saint Martin', prefix: '590'),
    Country(code: 'PM', name: 'Saint Pierre and Miquelon', prefix: '508'),
    Country(
        code: 'VC', name: 'Saint Vincent and the Grenadines', prefix: '1-784'),
    Country(code: 'WS', name: 'Samoa', prefix: '685'),
    Country(code: 'SM', name: 'San Marino', prefix: '378'),
    Country(code: 'ST', name: 'São Tomé and Príncipe', prefix: '239'),
    Country(code: 'SA', name: 'Saudi Arabia', prefix: '966'),
    Country(code: 'SN', name: 'Senegal', prefix: '221'),
    Country(code: 'RS', name: 'Serbia', prefix: '381'),
    Country(code: 'SC', name: 'Seychelles', prefix: '248'),
    Country(code: 'SL', name: 'Sierra Leone', prefix: '232'),
    Country(code: 'SG', name: 'Singapore', prefix: '65'),
    Country(code: 'SX', name: 'Sint Maarten', prefix: '1-721'),
    Country(code: 'SK', name: 'Slovakia', prefix: '421'),
    Country(code: 'SI', name: 'Slovenia', prefix: '386'),
    Country(code: 'SB', name: 'Solomon Islands', prefix: '677'),
    Country(code: 'SO', name: 'Somalia', prefix: '252'),
    Country(code: 'ZA', name: 'South Africa', prefix: '27'),
    Country(
        code: 'GS',
        name: 'South Georgia and the South Sandwich Islands',
        prefix: '500'),
    Country(code: 'KR', name: 'South Korea', prefix: '82'),
    Country(code: 'SS', name: 'South Sudan', prefix: '211'),
    Country(code: 'ES', name: 'Spain', prefix: '34'),
    Country(code: 'LK', name: 'Sri Lanka', prefix: '94'),
    Country(code: 'SD', name: 'Sudan', prefix: '249'),
    Country(code: 'SR', name: 'Suriname', prefix: '597'),
    Country(code: 'SJ', name: 'Svalbard and Jan Mayen', prefix: '47'),
    Country(code: 'SE', name: 'Sweden', prefix: '46'),
    Country(code: 'CH', name: 'Switzerland', prefix: '41'),
    Country(code: 'SY', name: 'Syria', prefix: '963'),
    Country(code: 'TW', name: 'Taiwan', prefix: '886'),
    Country(code: 'TJ', name: 'Tajikistan', prefix: '992'),
    Country(code: 'TZ', name: 'Tanzania', prefix: '255'),
    Country(code: 'TH', name: 'Thailand', prefix: '66'),
    Country(code: 'TL', name: 'Timor-Leste', prefix: '670'),
    Country(code: 'TG', name: 'Togo', prefix: '228'),
    Country(code: 'TK', name: 'Tokelau', prefix: '690'),
    Country(code: 'TO', name: 'Tonga', prefix: '676'),
    Country(code: 'TT', name: 'Trinidad and Tobago', prefix: '1-868'),
    Country(code: 'TN', name: 'Tunisia', prefix: '216'),
    Country(code: 'TR', name: 'Turkey', prefix: '90'),
    Country(code: 'TM', name: 'Turkmenistan', prefix: '993'),
    Country(code: 'TC', name: 'Turks and Caicos Islands', prefix: '1-649'),
    Country(code: 'TV', name: 'Tuvalu', prefix: '688'),
    Country(code: 'UG', name: 'Uganda', prefix: '256'),
    Country(code: 'UA', name: 'Ukraine', prefix: '380'),
    Country(code: 'AE', name: 'United Arab Emirates', prefix: '971'),
    Country(code: 'GB', name: 'United Kingdom', prefix: '44'),
    Country(code: 'US', name: 'United States', prefix: '1'),
    Country(code: 'UY', name: 'Uruguay', prefix: '598'),
    Country(code: 'UZ', name: 'Uzbekistan', prefix: '998'),
    Country(code: 'VU', name: 'Vanuatu', prefix: '678'),
    Country(code: 'VA', name: 'Vatican City', prefix: '39'),
    Country(code: 'VE', name: 'Venezuela', prefix: '58'),
    Country(code: 'VN', name: 'Vietnam', prefix: '84'),
    Country(code: 'WF', name: 'Wallis and Futuna', prefix: '681'),
    Country(code: 'EH', name: 'Western Sahara', prefix: '212'),
    Country(code: 'YE', name: 'Yemen', prefix: '967'),
    Country(code: 'ZM', name: 'Zambia', prefix: '260'),
    Country(code: 'ZW', name: 'Zimbabwe', prefix: '263')
  ];

  Country? selected;
  final TextEditingController _controller = TextEditingController();
  String? number;

  void _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          minChildSize: 0.5,
          maxChildSize: 0.5,
          initialChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  // line thingy at the very top
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  // content
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      controller: scrollController,
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, countries[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                // flag + name
                                Row(
                                  children: [
                                    CountryFlag.fromCountryCode(
                                      countries[index].code,
                                      width: 32,
                                      height: 32,
                                      shape: const Circle(),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      countries[index].name.length > 24 ? "${countries[index].name.substring(0, 22)}.."  : countries[index].name,
                                      style: GoogleFonts.mulish(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // phone code
                                Text(
                                  "+${countries[index].prefix}",
                                  style: GoogleFonts.mulish(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selected = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    selected = countries.first;

    _controller.addListener(() {
      setState(() {
        number = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PhoneAppbar(),
      body: Stack(
        children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 50,
                  children: [
                    SizedBox(height: 50),
                    TitleAndHeader(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 8,
                      children: [
                        GestureDetector( // dropdown button
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Color(0xffF7FBFD),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  selected!.code,
                                  width: 24,
                                  height: 24,
                                  shape: const Circle()
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '+${selected!.prefix}'
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.keyboard_arrow_down_sharp),
                              ]
                            )
                          )
                        ),
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly,
                              PhoneNumberInputFormatter(),
                            ],
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: '893 456 789',
                              fillColor: Color(0xffF7FBFD),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1
                                )
                              ),
                            )
                          ),
                        ),
                      ]
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selected != null && number != null && number!.isNotEmpty && number!.length >= 9) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PhoneVerify(code: selected!.prefix, number: number ?? '')
                              )
                            );
                          } else { // invalid phone number (fails above checks)
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Please enter a valid phone number')));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            (selected != null && number != null && number!.isNotEmpty && number!.length >= 9) 
                                ? const Color(0xFF6296FF) 
                                : Colors.grey,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    // Skip button to go directly to Home page
                    TextButton(
                      onPressed: () {
                        // Allow users to skip phone verification and go directly to home page
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                        'Skip for now',
                        style: GoogleFonts.mulish(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]
                )
              ),
            ),
            // background faded circle
            FadedCircle(
              top: -150,
              right: -100,
              width: 300,
              height: 300,
            )
          ]
        )
      );
  }
}

class PhoneAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PhoneAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      leadingWidth: 25,
      automaticallyImplyLeading: false,
      title: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.keyboard_arrow_left_sharp),
                Text(
                  'Back',
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      color: Color(0xff053742),
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                    )
                  )
                )
              ]
            ) 
          );
        }
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FadedCircle extends StatelessWidget {
  final double right;
  final double top;
  final double width;
  final double height;

  const FadedCircle({super.key, required this.right, required this.top, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0xff3CCEFF).withAlpha((0.6 * 255).toInt()),
              Color(0xff3CCEFF).withAlpha((0.1 * 255).toInt()),
            ],
            stops: [
              0.0,
              1.0
            ]
          )
        ),
      )
    );
  }
}

class TitleAndHeader extends StatelessWidget {
  const TitleAndHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Phone Number',
          textAlign: TextAlign.center,
          style: GoogleFonts.mulish(
            textStyle: TextStyle(
              color: Color(0xff053742),
              fontSize: 32,
              fontWeight: FontWeight.w600
            )
          ),
        ),
        Text(
          'Please enter your phone number to verify your account & receive a credit',
          textAlign: TextAlign.center,
          style: GoogleFonts.mulish(
            textStyle: TextStyle(
              color: Color(0xff88879C),
              fontSize: 16
            )
          )
        )
      ]
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');

    StringBuffer buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buf.write(' ');
      }
      buf.write(text[i]);
    }

    return TextEditingValue(
      text: buf.toString(),
      selection: TextSelection.collapsed(offset: buf.toString().length),
    );
  }
}
//phone number page done 