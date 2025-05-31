import 'dart:convert';
import 'package:courierflow/Map/Map.dart';

import 'package:courierflow/Home/bloc/scanning_bloc.dart';
import 'package:courierflow/Data/Location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanningBloc scanningBloc = ScanningBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      
      create: (context) => ScanningBloc(),
      child: BlocConsumer<ScanningBloc, ScanningState>(
        bloc: scanningBloc,
        listener: (context, state) {
          if (state is Added) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item added successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          else if (state is StartNavigation) {
            // Navigate to the navigation page with the GPX file
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Map(gpxString: """
<?xml version="1.0" encoding="UTF-8" standalone="no" ?><gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" creator="GraphHopper" version="1.1" xmlns:gh="https://graphhopper.com/public/schema/gpx/1.1">
<metadata><copyright author="OpenStreetMap contributors"/><link href="http://graphhopper.com"><text>GraphHopper GPX</text></link><time>2025-05-28T22:19:41.403Z</time></metadata>
<wpt lat="34.658284" lon="-1.948838"></wpt>
<wpt lat="34.661053" lon="-1.916946"></wpt>

<rte>
<rtept lat="34.658284" lon="-1.948838"><desc>Continue</desc><extensions><gh:distance>112.792</gh:distance><gh:time>25378</gh:time><gh:sign>0</gh:sign></extensions></rtept>
<rtept lat="34.657366" lon="-1.948313"><desc>Turn left</desc><extensions><gh:distance>69.814</gh:distance><gh:time>15708</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.657641" lon="-1.947628"><desc>Turn right</desc><extensions><gh:distance>32.388</gh:distance><gh:time>11660</gh:time><gh:sign>2</gh:sign></extensions></rtept>
<rtept lat="34.657378" lon="-1.947477"><desc>Continue</desc><extensions><gh:distance>234.782</gh:distance><gh:time>52827</gh:time><gh:sign>0</gh:sign></extensions></rtept>
<rtept lat="34.655462" lon="-1.946408"><desc>Turn left</desc><extensions><gh:distance>16.793</gh:distance><gh:time>3778</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.655550" lon="-1.946260"><desc>Turn right</desc><extensions><gh:distance>245.982</gh:distance><gh:time>55346</gh:time><gh:sign>2</gh:sign></extensions></rtept>
<rtept lat="34.654924" lon="-1.943683"><desc>Turn left</desc><extensions><gh:distance>87.91</gh:distance><gh:time>19780</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.654762" lon="-1.942964"><desc>Turn left</desc><extensions><gh:distance>120.274</gh:distance><gh:time>27062</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.654462" lon="-1.941701"><desc>Turn right</desc><extensions><gh:distance>321.681</gh:distance><gh:time>41358</gh:time><gh:sign>2</gh:sign></extensions></rtept>
<rtept lat="34.651644" lon="-1.942323"><desc>Turn left onto Rue E1</desc><extensions><gh:distance>224.229</gh:distance><gh:time>12613</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.650749" lon="-1.940161"><desc>Turn sharp right</desc><extensions><gh:distance>72.223</gh:distance><gh:time>4063</gh:time><gh:sign>3</gh:sign></extensions></rtept>
<rtept lat="34.650199" lon="-1.940576"><desc>Turn left</desc><extensions><gh:distance>413.351</gh:distance><gh:time>32349</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.648095" lon="-1.937021"><desc>Turn left</desc><extensions><gh:distance>1054.645</gh:distance><gh:time>59324</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.651747" lon="-1.926540"><desc>At roundabout, take exit 2 onto Route Aouinet Serrak</desc><extensions><gh:distance>374.339</gh:distance><gh:time>23585</gh:time><gh:sign>6</gh:sign></extensions></rtept>
<rtept lat="34.654171" lon="-1.924072"><desc>At roundabout, take exit 2 onto Route Aouinet Serrak</desc><extensions><gh:distance>928</gh:distance><gh:time>148374</gh:time><gh:sign>6</gh:sign></extensions></rtept>
<rtept lat="34.661567" lon="-1.919889"><desc>Turn right</desc><extensions><gh:distance>274.2</gh:distance><gh:time>61695</gh:time><gh:sign>2</gh:sign></extensions></rtept>
<rtept lat="34.660743" lon="-1.917066"><desc>Turn left</desc><extensions><gh:distance>36.397</gh:distance><gh:time>13102</gh:time><gh:sign>-2</gh:sign></extensions></rtept>
<rtept lat="34.661053" lon="-1.916946"><desc>Arrive at destination</desc><extensions><gh:distance>0</gh:distance><gh:time>0</gh:time><gh:sign>4</gh:sign></extensions></rtept>
</rte>
<trk>
<name>GraphHopper Track</name><desc></desc>
<trkseg><trkpt lat="34.658284" lon="-1.948838"><ele>592.3</ele></trkpt>
<trkpt lat="34.657366" lon="-1.948313"><ele>593.4</ele></trkpt>
<trkpt lat="34.657641" lon="-1.947628"><ele>590.6</ele></trkpt>
<trkpt lat="34.657378" lon="-1.947477"><ele>591.9</ele></trkpt>
<trkpt lat="34.656817" lon="-1.947144"><ele>592.9</ele></trkpt>
<trkpt lat="34.656543" lon="-1.947001"><ele>592.4</ele></trkpt>
<trkpt lat="34.655910" lon="-1.946645"><ele>596.5</ele></trkpt>
<trkpt lat="34.655462" lon="-1.946408"><ele>601.1</ele></trkpt>
<trkpt lat="34.655550" lon="-1.946260"><ele>600.0</ele></trkpt>
<trkpt lat="34.655319" lon="-1.945378"><ele>602.5</ele></trkpt>
<trkpt lat="34.654924" lon="-1.943683"><ele>609.1</ele></trkpt>
<trkpt lat="34.654956" lon="-1.943657"><ele>609.1</ele></trkpt>
<trkpt lat="34.655037" lon="-1.943546"><ele>608.6</ele></trkpt>
<trkpt lat="34.655052" lon="-1.943475"><ele>608.4</ele></trkpt>
<trkpt lat="34.655046" lon="-1.943438"><ele>608.3</ele></trkpt>
<trkpt lat="34.654951" lon="-1.943058"><ele>610.4</ele></trkpt>
<trkpt lat="34.654907" lon="-1.943008"><ele>610.8</ele></trkpt>
<trkpt lat="34.654862" lon="-1.942986"><ele>611.1</ele></trkpt>
<trkpt lat="34.654762" lon="-1.942964"><ele>611.8</ele></trkpt>
<trkpt lat="34.654462" lon="-1.941701"><ele>610.5</ele></trkpt>
<trkpt lat="34.653963" lon="-1.941701"><ele>613.2</ele></trkpt>
<trkpt lat="34.653556" lon="-1.941721"><ele>612.9</ele></trkpt>
<trkpt lat="34.653165" lon="-1.941793"><ele>609.4</ele></trkpt>
<trkpt lat="34.652794" lon="-1.941879"><ele>606.0</ele></trkpt>
<trkpt lat="34.651943" lon="-1.942232"><ele>603.7</ele></trkpt>
<trkpt lat="34.651644" lon="-1.942323"><ele>605.4</ele></trkpt>
<trkpt lat="34.651380" lon="-1.941825"><ele>604.2</ele></trkpt>
<trkpt lat="34.651044" lon="-1.941131"><ele>602.6</ele></trkpt>
<trkpt lat="34.650851" lon="-1.940708"><ele>601.6</ele></trkpt>
<trkpt lat="34.650785" lon="-1.940508"><ele>601.2</ele></trkpt>
<trkpt lat="34.650753" lon="-1.940377"><ele>600.9</ele></trkpt>
<trkpt lat="34.650741" lon="-1.940271"><ele>600.7</ele></trkpt>
<trkpt lat="34.650749" lon="-1.940161"><ele>600.5</ele></trkpt>
<trkpt lat="34.650648" lon="-1.940216"><ele>601.2</ele></trkpt>
<trkpt lat="34.650461" lon="-1.940361"><ele>602.5</ele></trkpt>
<trkpt lat="34.650199" lon="-1.940576"><ele>603.8</ele></trkpt>
<trkpt lat="34.650111" lon="-1.940546"><ele>603.8</ele></trkpt>
<trkpt lat="34.650078" lon="-1.940523"><ele>603.8</ele></trkpt>
<trkpt lat="34.650039" lon="-1.940468"><ele>603.7</ele></trkpt>
<trkpt lat="34.649847" lon="-1.940047"><ele>603.6</ele></trkpt>
<trkpt lat="34.649754" lon="-1.939905"><ele>603.6</ele></trkpt>
<trkpt lat="34.649637" lon="-1.939776"><ele>603.5</ele></trkpt>
<trkpt lat="34.649474" lon="-1.939647"><ele>603.5</ele></trkpt>
<trkpt lat="34.649224" lon="-1.939478"><ele>603.4</ele></trkpt>
<trkpt lat="34.649147" lon="-1.939409"><ele>603.3</ele></trkpt>
<trkpt lat="34.649090" lon="-1.939334"><ele>603.3</ele></trkpt>
<trkpt lat="34.649039" lon="-1.939162"><ele>603.3</ele></trkpt>
<trkpt lat="34.649020" lon="-1.939071"><ele>603.2</ele></trkpt>
<trkpt lat="34.649007" lon="-1.938947"><ele>603.2</ele></trkpt>
<trkpt lat="34.648987" lon="-1.938883"><ele>603.2</ele></trkpt>
<trkpt lat="34.648961" lon="-1.938825"><ele>603.2</ele></trkpt>
<trkpt lat="34.648653" lon="-1.938300"><ele>603.0</ele></trkpt>
<trkpt lat="34.648537" lon="-1.938030"><ele>602.9</ele></trkpt>
<trkpt lat="34.648477" lon="-1.937860"><ele>602.9</ele></trkpt>
<trkpt lat="34.648293" lon="-1.937402"><ele>602.8</ele></trkpt>
<trkpt lat="34.648160" lon="-1.937122"><ele>602.7</ele></trkpt>
<trkpt lat="34.648095" lon="-1.937021"><ele>602.6</ele></trkpt>
<trkpt lat="34.649537" lon="-1.934389"><ele>590.5</ele></trkpt>
<trkpt lat="34.649571" lon="-1.934319"><ele>590.1</ele></trkpt>
<trkpt lat="34.649622" lon="-1.934165"><ele>589.5</ele></trkpt>
<trkpt lat="34.649641" lon="-1.934082"><ele>589.2</ele></trkpt>
<trkpt lat="34.649655" lon="-1.933980"><ele>588.8</ele></trkpt>
<trkpt lat="34.649716" lon="-1.933225"><ele>589.2</ele></trkpt>
<trkpt lat="34.649794" lon="-1.932540"><ele>590.9</ele></trkpt>
<trkpt lat="34.649842" lon="-1.932306"><ele>591.5</ele></trkpt>
<trkpt lat="34.649932" lon="-1.932021"><ele>592.3</ele></trkpt>
<trkpt lat="34.650052" lon="-1.931671"><ele>593.3</ele></trkpt>
<trkpt lat="34.650450" lon="-1.930586"><ele>596.4</ele></trkpt>
<trkpt lat="34.650645" lon="-1.930099"><ele>597.8</ele></trkpt>
<trkpt lat="34.650948" lon="-1.929391"><ele>599.8</ele></trkpt>
<trkpt lat="34.651078" lon="-1.929066"><ele>599.4</ele></trkpt>
<trkpt lat="34.651207" lon="-1.928712"><ele>598.8</ele></trkpt>
<trkpt lat="34.651271" lon="-1.928510"><ele>598.5</ele></trkpt>
<trkpt lat="34.651453" lon="-1.927807"><ele>597.5</ele></trkpt>
<trkpt lat="34.651597" lon="-1.927149"><ele>596.6</ele></trkpt>
<trkpt lat="34.651657" lon="-1.926927"><ele>596.3</ele></trkpt>
<trkpt lat="34.651711" lon="-1.926631"><ele>598.1</ele></trkpt>
<trkpt lat="34.651747" lon="-1.926540"><ele>598.7</ele></trkpt>
<trkpt lat="34.651725" lon="-1.926517"><ele>599.0</ele></trkpt>
<trkpt lat="34.651690" lon="-1.926459"><ele>599.5</ele></trkpt>
<trkpt lat="34.651671" lon="-1.926392"><ele>600.0</ele></trkpt>
<trkpt lat="34.651674" lon="-1.926300"><ele>600.2</ele></trkpt>
<trkpt lat="34.651706" lon="-1.926217"><ele>600.3</ele></trkpt>
<trkpt lat="34.651762" lon="-1.926157"><ele>600.5</ele></trkpt>
<trkpt lat="34.651834" lon="-1.926128"><ele>600.6</ele></trkpt>
<trkpt lat="34.651909" lon="-1.926135"><ele>600.7</ele></trkpt>
<trkpt lat="34.652174" lon="-1.925899"><ele>600.6</ele></trkpt>
<trkpt lat="34.654068" lon="-1.924273"><ele>595.0</ele></trkpt>
<trkpt lat="34.654171" lon="-1.924072"><ele>594.4</ele></trkpt>
<trkpt lat="34.654161" lon="-1.924005"><ele>594.3</ele></trkpt>
<trkpt lat="34.654185" lon="-1.923934"><ele>594.2</ele></trkpt>
<trkpt lat="34.654242" lon="-1.923890"><ele>594.0</ele></trkpt>
<trkpt lat="34.654295" lon="-1.923889"><ele>593.9</ele></trkpt>
<trkpt lat="34.654341" lon="-1.923919"><ele>593.9</ele></trkpt>
<trkpt lat="34.654359" lon="-1.923943"><ele>593.9</ele></trkpt>
<trkpt lat="34.654377" lon="-1.924003"><ele>593.9</ele></trkpt>
<trkpt lat="34.654461" lon="-1.923995"><ele>593.7</ele></trkpt>
<trkpt lat="34.654545" lon="-1.923951"><ele>593.5</ele></trkpt>
<trkpt lat="34.654727" lon="-1.923835"><ele>592.9</ele></trkpt>
<trkpt lat="34.655025" lon="-1.923621"><ele>592.0</ele></trkpt>
<trkpt lat="34.655730" lon="-1.923122"><ele>590.6</ele></trkpt>
<trkpt lat="34.656340" lon="-1.922713"><ele>586.3</ele></trkpt>
<trkpt lat="34.657919" lon="-1.921624"><ele>582.4</ele></trkpt>
<trkpt lat="34.658233" lon="-1.921455"><ele>581.9</ele></trkpt>
<trkpt lat="34.659207" lon="-1.920996"><ele>580.0</ele></trkpt>
<trkpt lat="34.659978" lon="-1.920637"><ele>579.8</ele></trkpt>
<trkpt lat="34.660897" lon="-1.920184"><ele>577.7</ele></trkpt>
<trkpt lat="34.661567" lon="-1.919889"><ele>576.6</ele></trkpt>
<trkpt lat="34.661421" lon="-1.919360"><ele>577.4</ele></trkpt>
<trkpt lat="34.661312" lon="-1.919035"><ele>577.9</ele></trkpt>
<trkpt lat="34.661108" lon="-1.918369"><ele>579.6</ele></trkpt>
<trkpt lat="34.660768" lon="-1.917195"><ele>583.5</ele></trkpt>
<trkpt lat="34.660743" lon="-1.917066"><ele>583.9</ele></trkpt>
<trkpt lat="34.661053" lon="-1.916946"><ele>580.4</ele></trkpt>
</trkseg></trk>
</gpx>
"""),));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Scan Page'),),

            body: Column(
              children: [
                MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    facing: CameraFacing.back,
                  ),
                  onDetect: (capture) {
                    
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      scanningBloc.add(ScanBarcode(Location.fromJson(jsonDecode(barcode.rawValue!))));
                    }
                  },
                ),
                TextButton(onPressed: (){
                  scanningBloc.add(Start(locations: scanningBloc.getLocations()));

                }, child: Text("Start", style: TextStyle(color: Colors.greenAccent),))
              ],
            )
            
          );
        },
      ),
    );
  }
}