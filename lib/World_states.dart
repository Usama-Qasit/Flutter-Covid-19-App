import 'package:covid_tracker_app/Models/World_states_model.dart';
import 'package:covid_tracker_app/Services/states_services.dart';
import 'package:covid_tracker_app/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>  with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 3),
      vsync: this)..repeat();


  final colorlist = <Color> [
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5346),

  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .01,),
                FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder:(context,AsyncSnapshot<WorldStatesModel>snapshot){
                    if(!snapshot.hasData){
                      return Expanded(
                        flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            controller: _controller,
                            size: 50.0,
                          ),
                      );
                    }else{
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total":double.parse(snapshot.data!.cases.toString()),
                              "Recovered":double.parse(snapshot.data!.recovered.toString()),
                              "Deaths":double.parse(snapshot.data!.deaths.toString()),
                            },
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true
                            ),
                            chartRadius: MediaQuery.of(context).size.width / 3.2,
                            legendOptions: LegendOptions(
                                legendPosition: LegendPosition.left
                            ),
                            chartType: ChartType.ring,
                            colorList: colorlist,
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * .06),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                  ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                  ReusableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                  ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                  ReusableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                  ReusableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),

                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesList()));
                    },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text('Track Countries')),


                            ),
                          )
                        ],
                      );
                    }

                }
                ),


              ],
            ),
          )
      ),
    );
  }
}


class ReusableRow extends StatelessWidget {
  String title, value;
   ReusableRow({Key? key,required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}
