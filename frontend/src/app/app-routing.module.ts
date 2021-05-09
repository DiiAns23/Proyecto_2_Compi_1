import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { from } from 'rxjs';
import { EditorComponent } from "./components/editor/editor.component";
import { HttpClient } from '@angular/common/http';

const routes: Routes = [
  {
    path: '',
    component: EditorComponent,
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { 
  constructor(private http: HttpClient){}

  uploadFile(formData:any){
    let urlApi = 'http:/localhost:4200/api/subir';
    return this.http.post(urlApi,formData);
  }
}
