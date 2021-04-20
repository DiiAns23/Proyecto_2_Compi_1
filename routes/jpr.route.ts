import {Router} from 'express';

const router:Router = Router();

import {controller} from '../jpr.controller';

router.get('/',controller.interpretar);

export default router;
