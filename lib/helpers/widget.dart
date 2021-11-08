import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:form_field_validator/form_field_validator.dart';

PreferredSizeWidget appBar(String text) {
  return AppBar(
        title          : Text(text, style: TextStyle(color: Colors.black)),
        elevation      : 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: HexColor('#FFFFFF'),
      );
}

const List<String> months = const <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> value_months = const <String>[
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
];

const List<String> years = const <String>[
  '2019',
  '2020',
  '2021',
  '2022',
  '2023',
  '2024',
  '2025',
  '2026',
  '2027',
];

String toNumberRupiah(value){
  return 'Rp. ${NumberFormat.decimalPattern('id_ID').format(value)}';
}

double dateToDouble(value){
  return double.parse(value.replaceAll('-', ''));
}
EdgeInsetsGeometry FormMargin = EdgeInsets.only(top: 5);

class FormLoading extends StatefulWidget {
  final String label;
  FormLoading({Key? key, required this.label}) : super(key: key);

  @override
  State<FormLoading> createState() => FormLoadingState();
}

class FormLoadingState extends State<FormLoading> {
  // String label = widget.label ?? 'Tes'; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: FormMargin,
      child: new TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.all(5),
          suffixIcon: Icon(MdiIcons.loading)
        ),
        initialValue: 'Loading ....',
        enabled: false,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

class FormText extends StatefulWidget {
  final String label;
  final dynamic initialValue;
  final bool disabled;
  final dynamic validator;
  final TextEditingController? valueController;
  final TextInputType? keyboardType;
  final bool isLoading;
  FormText({Key? key, required this.label, this.initialValue, this.disabled = false, this.validator, this.valueController, this.keyboardType, this.isLoading = false}) : super(key: key);

  @override
  State<FormText> createState() => FormTextState();
}

class FormTextState extends State<FormText> {
  // String label = widget.label ?? 'Tes'; 

  @override
  Widget build(BuildContext context) {
    if(widget.isLoading){
      return FormLoading(label: widget.label);
    }else{
      return Container(
        margin: FormMargin,
        child: new TextFormField(
          decoration: InputDecoration(
            labelText: widget.label,
            contentPadding: EdgeInsets.all(5),
          ),
          initialValue: widget.initialValue,
          enabled: !widget.disabled,
          controller: widget.valueController,
          keyboardType: widget.keyboardType,
          // validator: RequiredValidator(errorText: 'this field is required'),
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          validator: (val){
            // if (val!.isEmpty) {
            //   return '${widget.label} is empty';
            // }
            return null;
          },
        ),
      );
    }
  }
}

class FormSelect extends StatefulWidget {
  final String label;
  final bool disabled;
  final dynamic validator;
  final dynamic option;
  final TextEditingController valueController;
  final Function? refreshData;
  FormSelect({Key? key, required this.label, this.disabled = false, this.validator, required this.option, required this.valueController, this.refreshData = null}) : super(key: key);

  @override
  State<FormSelect> createState() => FormSelectState();
}


class FormSelectState extends State<FormSelect> {
  @override
  Widget build(BuildContext context) {
    return widget.option.length > 0 ? 
      _FormSelect(
        label          : widget.label,
        option         : widget.option,
        valueController: widget.valueController,
        key            : widget.key,
        disabled       : widget.disabled,
        validator      : widget.validator,
        refreshData    : widget.refreshData
      ) : FormLoading(label: widget.label);
  }
}

class _FormSelect extends StatefulWidget {
  final String label;
  final bool disabled;
  final dynamic validator;
  final dynamic option;
  final TextEditingController valueController;
  final Function? refreshData;
  _FormSelect({Key? key, required this.label, this.disabled = false, this.validator, required this.option, required this.valueController, this.refreshData}) : super(key: key);

  @override
  State<_FormSelect> createState() => _FormSelectState();
}

class _FormSelectState extends State<_FormSelect> {

  TextEditingController get _effectiveController => widget.valueController;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    var initialName = '';
    var initialValue = '';
    if(widget.option.length > 0){
      if(widget.valueController.text == ''){
        initialName = widget.option[0]['name'];
        initialValue = widget.option[0]['value'];
      }else{
        initialName = widget.option.where((e) => e['value'] == widget.valueController.text).toList()[0]['name'];
        initialValue = widget.option.where((e) => e['value'] == widget.valueController.text).toList()[0]['value'];
      }
    }

    setState(() {
      textController            = TextEditingController(text:  initialName);
      _effectiveController.text = initialValue;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: FormMargin,
      child: new TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.all(5),
          suffixIcon: Icon(MdiIcons.panDown)
        ),
        readOnly: true,
        enabled: !widget.disabled,
        controller: textController,
        onTap: (){
          showDialog(context: context, builder: (_) =>Dialog(
            child: Container(
              // height: MediaQuery.of(context).size.height / 2,
              width : double.infinity,
              child : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: MyColor('line'), width: 1)
                        )
                      ),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HexColor('#1d608a'))),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, color: Colors.grey.shade800, size: 16),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(0, 0),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(5),
                              primary: Colors.grey,
                              onPrimary: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: widget.option.length,
                        // controller: _scrollController,
                        shrinkWrap: true,
                          itemBuilder: (context, i){
                            return InkWell(
                              onTap: (){
                                if(widget.refreshData != null){
                                  widget.refreshData!();
                                }
                                setState(() {
                                  textController = TextEditingController(text: widget.option[i]['name']);
                                });
                                _effectiveController.text = widget.option[i]['value'] ?? ''; 
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: MyColor('bg'), width: 1)
                                  ),
                                  color: Colors.white
                                ),
                                child: Text(widget.option[i]['name'] ?? ''),
                              ),
                            );
                          },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        },
        validator: (val){
          if (val!.isEmpty) {
            return '${widget.label} is empty';
          }
          return null;
        },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
class FormDate extends StatefulWidget{

  final String label;
  final bool disabled;
  final dynamic validator;
  final TextEditingController valueController;
  final bool isLoading;
  FormDate({Key? key, required this.label, this.disabled = false, this.validator, required this.valueController, this.isLoading = false}) : super(key: key);

  @override
  State<FormDate> createState() => _FormDateState();
}

class _FormDateState extends State<FormDate> {
  @override
  Widget build(BuildContext context) {
    if(widget.isLoading){
      return FormLoading(label: widget.label);
    }else{
      return FormDate2(
        label          : widget.label,
        disabled       : widget.disabled,
        validator      : widget.validator,
        valueController: widget.valueController,
      );
    }
  }
}
class FormDate2 extends StatefulWidget {
  final String label;
  final bool disabled;
  final dynamic validator;
  final TextEditingController valueController;
  FormDate2({Key? key, required this.label, this.disabled = false, this.validator, required this.valueController}) : super(key: key);

  @override
  State<FormDate2> createState() => FormDate2State();
}


class FormDate2State extends State<FormDate2> {

  TextEditingController get _effectiveController => widget.valueController;
  TextEditingController textController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context    : context,
      initialDate: new DateFormat("y-MM-d").parse(widget.valueController.text),   // Refer step 1
      firstDate  : DateTime(1800),
      lastDate   : DateTime(2045),
    );
    if (picked != null && picked != new DateFormat("y-MM-dd").parse(widget.valueController.text))
      setState(() {
        selectedDate = picked;
      });
      
    _effectiveController.text = DateFormat('y-MM-dd').format(picked ?? new DateFormat("y-MM-dd").parse(widget.valueController.text));
    textController = TextEditingController(text: DateFormat('y-MM-dd').format(picked ?? new DateFormat("y-MM-dd").parse(widget.valueController.text)));
  }

  @override
  void initState() {
    print(widget.valueController.text);
    setState(() {
      textController = TextEditingController(text:  widget.valueController.text);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: FormMargin,
      child: new TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.all(5),
          suffixIcon: Icon(MdiIcons.calendar)
        ),
        readOnly: true,
        enabled: !widget.disabled,
        controller: textController,
        onTap: (){
          _selectDate(context);
        },
        // validator: (val){
        //   formValidation(val, widget);
        // },
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

// formValidation(val, widget){
//   String label     = widget.label;
//   String validator = widget.validator;
//   if (val!.isEmpty) {
//     return '${label} is empty';
//   }
//   return null;
// }