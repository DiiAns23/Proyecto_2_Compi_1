'use strict'
const express = require('express');
const bodParser = require('body-parser');
let cors = require('cors');

const app = express()
const parser = require('./parser')

app.use(bodParser.json({limit:'50mb', extended:true}))
app.use(bodParser.urlencoded({limit:'50mb', extended:true}))
app.use(cors())

const analizar = require('./Endpoint/analizadores')(parser, app)
const abrir = require('./Endpoint/analizadores')(parser,app)
app.listen('3000', ()=>{
    console.log("Servidor en puerto 4200")
})