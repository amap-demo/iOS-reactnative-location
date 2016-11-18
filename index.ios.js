/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component, PropTypes } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  MapView,
  View,
  TouchableHighlight,
} from 'react-native';

import { NativeModules, NativeEventEmitter } from 'react-native';
var LocationManager = NativeModules.AMapRCLocationManager;

const myModuleEvt = new NativeEventEmitter(LocationManager)
myModuleEvt.addListener('amapLocationDidChange', (data) => console.log(data))

class CustomButton extends React.Component {
  render() {
    return (
      <TouchableHighlight
        style={styles.button}
        underlayColor="#a5a5a5"
        onPress={this.props.onPress}>
        <Text style={styles.buttonText}>{this.props.text}</Text>
      </TouchableHighlight>
    );
  }
}

export default class HelloRN extends Component {
  constructor(props){
    super(props);
    this.state={
        location:'',
        regeo:'',
    }
  }
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
        <Text>
          Callback返回数据为:{this.state.location.latitude},{this.state.location.longitude}{'\n'}
          Address:{this.state.regeo.address}
        </Text>
        <CustomButton text="点击调用原生模块getLocation方法"
            onPress={()=>LocationManager.getLocation((error, location, regeo)=>{
                if(error) {
                  console.log(error);
                } else {
                  // console.log(location)
                  // console.log(regeo)
                  this.setState({location:location, regeo:regeo});
                }
              }
            )}
        />
      </View> 
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('HelloRN', () => HelloRN);
