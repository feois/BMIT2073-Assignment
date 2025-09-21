
import 'package:assignment/classes/delivery.dart';
import 'package:assignment/classes/part.dart';
import 'package:assignment/database.dart';
import 'package:assignment/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDelivery extends StatefulWidget {
  const AddDelivery({super.key});

  @override
  State<StatefulWidget> createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  bool _submitting = false;

  final _formKey = GlobalKey<FormState>();
  late int _part;
  late int _quantity;
  late String _destination;
  DateTime? _date;
  DeliveryPriority? _priority;

  final _dateCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    Database.fetch();
  }

  Future<void> _submit() async {
    final delivery = Delivery(
      id: 0,
      partId: _part,
      quantity: _quantity,
      destination: _destination,
      orderDate: DateTime.now(),
      requiredDate: _date!,
      priority: _priority!,
    );
    final json = delivery.toJson();

    json.remove('id'); // let supabase auto generate

    await Database.supabase.from(Database.deliveryTable).insert(json);

    snack(this, 'Delivery added successfully');

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Iterable<Part> _search(String query) {
    final id = int.tryParse(query);
    
    return Database.parts.where(
      (part) => (id != null ? matchString(part.id.toString(), id.toString()) : false) || matchString(part.name, query)
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(title: const Text('Add delivery')),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            spacing: 32,
            children: [
              Autocomplete<int>(
                optionsBuilder: (text) => text.text.isEmpty ? const Iterable.empty() : _search(text.text).map((part) => part.id),
                displayStringForOption: (part) => part.toString(),
                fieldViewBuilder: (_, ctrl, focus, submit) => TextFormField(
                  controller: ctrl,
                  focusNode: focus,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.settings),
                    labelText: 'Part ID',
                  ),
                  onFieldSubmitted: (_) => submit(),
                  onSaved: (part) => _part = int.parse(part!),
                  validator: (part) => validateInt(
                    part!,
                        (part) => Database.partsMap.containsKey(part),
                    empty: 'Part ID required!',
                    nan: 'Only integers allowed!',
                    invalidated: 'Part ID not found!',
                  ),
                ),
                optionsViewBuilder: (_, select, options) => Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView(
                        shrinkWrap: true,
                        children: options.map(Part.fromCache).map((part) => ListTile(
                          leading: Image.network(part.image, width: 32, height: 32),
                          title: Text(part.name),
                          subtitle: Text(part.id.toString()),
                          onTap: () => select(part.id),
                        )).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  icon: Icon(Icons.shopping_cart),
                  labelText: 'Quantity',
                ),
                onSaved: (quantity) => _quantity = int.parse(quantity!),
                validator: (quantity) => validateInt(
                  quantity!,
                      (quantity) => quantity > 0,
                  empty: 'Quantity required!',
                  nan: 'Only integers allowed!',
                  invalidated: 'Quantity must be more than zero!',
                ),
              ),
              TextFormField(
                initialValue: '',
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Destination',
                ),
                onSaved: (destination) => _destination = destination!.trim(),
                validator: (destination) => destination!.trim().isEmpty ? 'Destination cannot be empty!' : null,
              ),
              TextFormField(
                controller: _dateCtrl,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Required by',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(9999)
                      );

                      if (date != null) {
                        _dateCtrl.text = dateFormat.format(date);
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                onSaved: (date) => _date = dateFormat.parseLoose(date!),
                validator: (str) {
                  if (str!.isEmpty) return 'Date required!';

                  final date = dateFormat.tryParseLoose(str);

                  return date == null || date.isBefore(DateTime.now()) ? 'Invalid date!' : null;
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.priority_high),
                  labelText: 'Priority',
                ),
                items: DeliveryPriority.values.map(
                  (priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString()),
                  )
                ).toList(),
                onChanged: (priority) => setState(() => _priority = priority),
                validator: (priority) => priority == null ? 'Priority required!' : null,
              ),
              _submitting ? const CircularProgressIndicator() : Center(child: ElevatedButton(
                onPressed: () async {
                  setState(() => _submitting = true);

                  FocusScope.of(context).unfocus();

                  await Database.fetch();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _submit();
                  }

                  setState(() => _submitting = false);
                },
                child: const Text('Add')),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
