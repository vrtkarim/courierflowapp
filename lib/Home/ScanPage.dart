import 'dart:convert';

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
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Scan Page'),),

            body: MobileScanner(
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
            )
            
          );
        },
      ),
    );
  }
}