import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/api/car_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/util.dart';
import 'package:carros/widgets/my_custom_button.dart';
import 'package:carros/widgets/my_custom_input_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CarFormPage extends StatefulWidget {
  final Car car;

  CarFormPage({this.car});

  @override
  State<StatefulWidget> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  File _file;

  Car get car => widget.car;

  // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Oops campo obrigatório.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (car != null) {
      print(car);
      tNome.text = car.nome;
      tDesc.text = car.descricao;
      _radioIndex = getTipoInt(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: this._formKey,
      child: ListView(
        children: <Widget>[
          if (car == null) backButton(),
          if (car == null) Divider(),
          if (car == null) SizedBox(height: 10),
          _headerFoto(),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Tipo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          _radioTipo(),
          Divider(),
          SizedBox(
            height: 20,
          ),
          MyCustomInputText(
            "Nome",
            "digite o nome",
            tNome,
            _validateNome,
            TextInputType.text,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: tDesc,
            validator: _validateNome,
            maxLines: 8,
            decoration: InputDecoration(
                hintText: "sua descrição... ",
                border: OutlineInputBorder(),
                labelText: 'Descrição'),
          ),
          SizedBox(
            height: 25,
          ),
          MyCustomButton(
            "Salvar",
            _onClickSalvar,
            show: _showProgress,
          ),
        ],
      ),
    );
  }

  InkWell backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('Voltar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  _headerFoto() {
    return InkWell(
      onTap: _onCLickPhoto,
      child: _file != null
          ? Image.file(_file, height: 150,)
          : car != null
              ? CachedNetworkImage(
                  imageUrl: car.urlFoto,
                )
              : Image.asset(
                  "assets/photo"
                  ".png",
                  height: 150,
                ),
    );
  }

  _radioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Clássicos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Esportivos",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Luxo",
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Car car) {
    switch (car.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Cria o carro
    var c = car ?? Car();
    c.nome = tNome.text;
    c.descricao = tDesc.text;
    c.tipo = _getTipo();
    setState(() {
      _showProgress = true;
    });
    ApiResponse<bool> response = await CarAPi.save(c, _file);
    if (response.ok) {
      alert(context, "Ação realizada com sucesso!", callback: () {
        EventBus.get(context).sendEvent(CarroEvent("carro_salvo", c.tipo));
        //novo carro volta para o home editar não
        if (car == null) pop(context);
      });
    } else
      defaultAlert(context, "Ops", "Função para Adiministrador!\n Error: ",
          AlertType.warning,
          img: true);

    setState(() {
      _showProgress = false;
    });
  }

  void _onCLickPhoto() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        this._file = file;
      });
    }
  }
}
