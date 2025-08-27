import { Test, TestingModule } from '@nestjs/testing';
import { BorrowingTransactionsController } from './borrowing_transactions.controller';
import { BorrowingTransactionsService } from './borrowing_transactions.service';

describe('BorrowingTransactionsController', () => {
  let controller: BorrowingTransactionsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BorrowingTransactionsController],
      providers: [BorrowingTransactionsService],
    }).compile();

    controller = module.get<BorrowingTransactionsController>(BorrowingTransactionsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
