import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/widget/button_widget.dart';
import 'package:flutter_project/interficie/widget/edit_car_arguments.dart';
import 'package:flutter_project/interficie/widget/lateral_menu_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditCarPage extends StatefulWidget {
  const EditCarPage({Key? key}) : super(key: key);

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final formKey = GlobalKey<FormState>();

  //controllers for each value
  final controllerBrandCar = TextEditingController();
  final controllerModelCar = TextEditingController();
  final controllerNameCar = TextEditingController();
  final controllerBatteryCar = TextEditingController();
  final controllerEffciencyCar = TextEditingController();

  //here goes the values of inputs that has to input
  String? selectedNameCar;
  String? selectedBrandCar;
  String? selectedModelCar;
  String? selectedBatteryCar;
  String? selectedEffciencyCar;

  List<String> selectedPlugs = <String>[];
  List<String> brandList = <String>[];
  List<String> modelList = <String>[];


  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as EditCarArguments;
    controllerNameCar.text = car.carInfo[1];
    controllerBrandCar.text = car.carInfo[2];
    controllerModelCar.text = car.carInfo[3];
    controllerBatteryCar.text = car.carInfo[4];
    controllerEffciencyCar.text = car.carInfo[5];
    selectedPlugs = [];
    for(var i = 6; i < car.carInfo.length; ++i){
      selectedPlugs.add(car.carInfo[i]);
    }

    ctrlPresentation.getBrandList().then((element){
      brandList = element;
    });
    String plugTitle = AppLocalizations.of(context).chargerTypeLabel;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editCar),
        centerTitle: true,
        backgroundColor: mCardColor,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    buildTextNoSuggestorField(
                      icon: Icons.badge,
                      hint: AppLocalizations.of(context).carNameHint,
                      label: AppLocalizations.of(context).carNameLabel,
                      controller: controllerNameCar,
                      returnable: "selectedNameCar",
                    ),
                    const SizedBox(height: 13),
                    buildTextSuggestorField(
                      icon: Icons.policy,
                      hint: 'Tesla',
                      label: AppLocalizations.of(context).carBrand,
                      controller: controllerBrandCar,
                      suggester: getBrandSuggestions,
                      returnable: "selectedBrandCar",
                    ),
                    const SizedBox(height: 13),
                    buildTextSuggestorField(
                      icon: Icons.sort,
                      hint: 'Model 3 Long Range Dual Motor',
                      label: AppLocalizations.of(context).carModelLabel,
                      controller: controllerModelCar,
                      suggester: getModelSuggestions,
                      returnable: "selectedModelCar",
                    ),
                    const SizedBox(height: 13),
                    buildNumFieldBattery(
                      icon: Icons.battery_charging_full,
                      hint: '107.8',
                      label: AppLocalizations.of(context).carBatteryLabel,
                      controller: controllerBatteryCar,
                      returnable: "selectedBatteryCar",
                    ),
                    const SizedBox(height: 13),
                    buildNumFieldEfficiency(
                      icon: Icons.battery_unknown,
                      hint: '168',
                      label: AppLocalizations.of(context).carEfficiency,
                      controller: controllerEffciencyCar,
                      returnable: "selectedEffciencyCar",
                    ),

                    const SizedBox(height: 30),
                    ListTile(
                      leading: const Icon(Icons.settings_input_svideo, color: Colors.black, size: 24,),
                      title: Text(
                        plugTitle,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    for(var i = 0; i < allPlugTypeList.length; i++) buildCheckbox(allPlugTypeList[i], car.carInfo.contains(allPlugTypeList[i])),
                    const SizedBox(height: 30),
                    buildSubmit(context, car.carInfo[0])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextSuggestorField({
    required String hint,
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required List<String> Function(String query) suggester,
    required var returnable,
  }) {
    return TypeAheadFormField<String?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: suggester,
      itemBuilder: (context, String? suggestion) {
        modelList.clear();
        return ListTile(
          title: Text(suggestion!),
        );
      },
      onSuggestionSelected: (String? suggestion) {
        controller.text = suggestion!;
        ctrlPresentation.getModelList(controllerBrandCar.text).then((element){
          modelList = element;
        });
        List<String> infoModel = ctrlPresentation.getInfoModel(controllerModelCar.text);
        controllerBatteryCar.text = infoModel[3];//3.bateria kWh
        controllerEffciencyCar.text = infoModel[5];//5.eficiencia Wh/Km
      },
      validator: (value) {
        return value!.isEmpty ? AppLocalizations.of(context).carBrandLabel : null;
      },
      onSaved: (value) {
        saveRoutine(value, returnable);
      },
    );
  }

  Widget buildTextNoSuggestorField({
    required String hint,
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required var returnable,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: 15,
      maxLengthEnforcement: MaxLengthEnforcement.none,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return AppLocalizations.of(context).carBrandLabel;
        } else if (value!.length > 15){
          return AppLocalizations.of(context).maxCharMssg;
        }
        else {
          return null;
        }
      },
      onSaved: (value) {
        saveRoutine(value, returnable);
      },
    );
  }

  Widget buildCheckbox(String plugName, bool initValue) => CheckboxListTileFormField(
    title: Text(plugName),
    validator: (value) {
      if(allPlugTypeList.length-1 == allPlugTypeList.indexOf(plugName)) {
        return selectedPlugs.isEmpty ? AppLocalizations.of(context).msgSelectChargers : null;
      }
      return null;
    },
    onSaved: (bool? value) {
    },
    onChanged: (value) {
      if (value) {
        selectedPlugs.add(plugName);
      } else {
        selectedPlugs.remove(plugName);
      }
    },
    initialValue: initValue,
    autovalidateMode: AutovalidateMode.always,
    contentPadding: const EdgeInsets.all(1),
  );

  Widget buildNumFieldBattery({
    required String hint,
    required String label,
    required IconData icon,
    required TextEditingController controller, String? returnable,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        double minBattery = 10;
        double maxBattery = 300;
        if(value == null) {
          return null;
        }
        final n = num.tryParse(value);
        if(n == null) {
          return AppLocalizations.of(context).msgIntroNum;
        } else if (double.parse(controllerBatteryCar.text) < minBattery) {
          controllerBatteryCar.text = minBattery.toStringAsFixed(2);
          return AppLocalizations.of(context).minValueCarForm(minBattery.toString());
        } else if (double.parse(controllerBatteryCar.text) > maxBattery) {
          controllerBatteryCar.text = maxBattery.toStringAsFixed(2);
          return AppLocalizations.of(context).maxValueCarForm(maxBattery.toString());
        }
        return null;
      },
      onSaved: (value) {
        saveRoutine(value, returnable);
      },
    );
  }

  Widget buildNumFieldEfficiency({
    required String hint,
    required String label,
    required IconData icon,
    required TextEditingController controller, String? returnable,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        double minEfficiency = 30;
        double maxEfficiency = 1000;
        if(value == null) {
          return null;
        }
        final n = num.tryParse(value);
        if(n == null) {
          return AppLocalizations.of(context).msgIntroNum;
        } else if (double.parse(controllerEffciencyCar.text) < minEfficiency) {
          controllerEffciencyCar.text = minEfficiency.toStringAsFixed(2);
          return AppLocalizations.of(context).minValueCarForm(minEfficiency.toString());
        } else if (double.parse(controllerEffciencyCar.text) > maxEfficiency) {
          controllerEffciencyCar.text = maxEfficiency.toStringAsFixed(2);
          return AppLocalizations.of(context).maxValueCarForm(maxEfficiency.toString());
        }
        return null;
      },
      onSaved: (value) {
        saveRoutine(value, returnable);
      },
    );
  }

  Widget buildSubmit(BuildContext context, String carId) => ButtonWidget(
    text: AppLocalizations.of(context).save,
    onClicked: () {
      final form = formKey.currentState!;
      form.save();
      if (form.validate()) {
        ctrlPresentation.saveEditedCar(
            context,
            carId,
            selectedNameCar!,
            selectedBrandCar!,
            selectedModelCar!,
            selectedBatteryCar!,
            selectedEffciencyCar!,
            selectedPlugs
        );
      }

      else{
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context).infoCar(selectedNameCar.toString(), selectedBrandCar.toString(), selectedModelCar.toString(), selectedBatteryCar.toString(), selectedEffciencyCar.toString(), selectedPlugs.toString())),
          ));
      }
    },
    icon: Icons.save,
  );

  void saveRoutine(String? value, returnable) {
    switch(returnable) {
      case "selectedModelCar": {
        selectedModelCar = value;
        break;
      }
      case "selectedBrandCar": {
        selectedBrandCar = value;
        break;
      }
      case "selectedNameCar": {
        selectedNameCar = value;
        break;
      }
      case "selectedBatteryCar": {
        selectedBatteryCar = value;
        break;
      }
      case "selectedEffciencyCar": {
        selectedEffciencyCar = value;
        break;
      }
    }
  }

  List<String> getBrandSuggestions(String query) {
    return List.of(brandList).where((brand) {
      final brandLower = brand.toLowerCase();
      final queryLower = query.toLowerCase();

      return brandLower.contains(queryLower);
    }).toList();
  }

  List<String> getModelSuggestions(String query) {
    return List.of(modelList).where((brand) {
      final brandLower = brand.toLowerCase();
      final queryLower = query.toLowerCase();

      return brandLower.contains(queryLower);
    }).toList();
  }

}