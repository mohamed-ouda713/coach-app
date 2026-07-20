import 'package:flutter/material.dart';
import 'package:glow_up/core/screens/home_page.dart';
import 'package:glow_up/core/theme/app_theme.dart';
import 'package:glow_up/widgets/Buttons/Primary_Buttons/ActionIcon_Button.dart';
import 'package:glow_up/widgets/Buttons/Primary_Buttons/SaveButton.dart';
import 'package0/glow_up/widgets/Buttons/Primary_Buttons/Secondary_Button.dart';
import 'package:glow_up/widgets/Buttons/Primary_Buttons/Selectable_Button.dart';
import 'package:glow_up/widgets/Buttons/Primary_Buttons/custom_icon_button.dart';
import 'package:glow_up/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package0/glow_up/widgets/Buttons/Text_Buttons/custom_text_link.dart';
import 'package:glow_up/widgets/inputs/Secrach_bar_widget/serch_widget.dart';
import 'package:glow_up/widgets/inputs/custem_text-filed/Measurement_Card.dart';
import 'package:glow_up/widgets/inputs/date_input_filed/input_Text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ActioniconButton(
                  icon: Icons.add,
                  onPressed: () {},
                  ContainerColor: Colors.red,
                  iconColor: Colors.black,
                ),
                CustomIconButton(
                  icon: Icons.add,
                  onPressed: () {},
                  color: Colors.red,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 15),
                primary_Buttons(title: 'ارسال', ContinerColor: Colors.blue),
                const SizedBox(height: 15),
                Savebutton(title: 'حفظ التغيرات', ContainerColor: Colors.blue),
                const SizedBox(height: 15),
                SecondryButtons(
                  title: 'التالي',
                  onTap: () {},
                  colorContainer: Colors.grey,
                ),
                CustomTextLink(color: Colors.blue, Titel: 'انقر هنا'),
                CusttemTextForm(
                  TitelTexst: 'الاسم',
                  labelText: 'الاسم',
                  hintText: 'الاسم',
                ),
                CusttemTextForm(TitelTexst: 'hello', hintText: 'hello'),
                MeasurementCard(Titel: '72', labelText: 'االوزن', SubTitel: 'كغ'),
                AddDate(
                  Titel: '20/01/2020',
                  labelText: 'Date',
                  icon: Icons.date_range,
                ),
                SerchWidget(),
                SelectedButton(title: 'selected'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
