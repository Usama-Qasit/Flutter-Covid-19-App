import 'package:covid_tracker_app/Services/states_services.dart';
import 'package:covid_tracker_app/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({Key? key}) : super(key: key);

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                  future:statesServices.countriesListApi(),
                    builder:(context,AsyncSnapshot<List<dynamic>> snapshot){
                      if(!snapshot.hasData){
                        return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context,index){
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey.shade700,
                                child:  Column(
                              children: [
                              ListTile(
                              title:Container(height:10,width: 80,color: Colors.white,),
                              subtitle:Container(height:10,width: 80,color: Colors.white,),
                              leading: Container(height:50,width: 50,color: Colors.white,),
                              )

                              ],
                              ),
                                  );


                            });
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                            itemBuilder: (context,index){
                            String name = snapshot.data![index]['country'];

                            if(searchController.text.isEmpty){
                              return Column(
                                children: [
                                  ListTile(
                                    title:Text(snapshot.data![index]['country']),
                                    subtitle:Text(snapshot.data![index]['cases'].toString()),
                                    leading: Image(
                                        height:50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]['countryInfo']['flag']
                                        )),
                                  )

                                ],
                              );
                            }else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                              return Column(
                                children: [
                                  InkWell(
                                    child: ListTile(
                                      onTap:(){
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context)=>DetailScreen(
                                                  name: snapshot.data![index]['country'],
                                                  image: snapshot.data![index]['countryInfo']['flag'],
                                                  totalCases: snapshot.data![index]['cases'],
                                                  totalRecovered: snapshot.data![index]['recovered'],
                                                  totalDeaths: snapshot.data![index]['deaths'],
                                                  active: snapshot.data![index]['active'],
                                                  test: snapshot.data![index]['tests'],
                                                  todayRecovered: snapshot.data![index]['todayRecovered'],
                                                  critical: snapshot.data![index]['critical'],
                                                )));
                              },
                                      title:Text(snapshot.data![index]['country']),
                                      subtitle:Text(snapshot.data![index]['cases'].toString()),
                                      leading: Image(
                                          height:50,
                                          width: 50,
                                          image: NetworkImage(
                                              snapshot.data![index]['countryInfo']['flag']
                                          )),
                                    ),
                                  )

                                ],
                              );
                            }else{
                              return Container();
                            }


                            });
                      }

                    },
                ),
            )
          ],
        ),
      ),
    );
  }
}
