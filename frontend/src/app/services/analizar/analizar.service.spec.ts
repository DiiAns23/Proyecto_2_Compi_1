import { TestBed } from '@angular/core/testing';

import { AnalizarService } from './analizar.service';

describe('AnalizarService', () => {
  let service: AnalizarService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AnalizarService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
