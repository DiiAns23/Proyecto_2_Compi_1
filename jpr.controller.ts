import {Request,Response} from 'express';


class rjpController{

    public interpretar (req:Request,res:Response){
        var parser = require("./parser")
        parser.parse(`
        print(8^2);
        int a = 10;
        print(a+10);
        if(a == 10){
            print("Si esta funcionando");
        }
        `);
    }
    
}   
export const controller = new rjpController();