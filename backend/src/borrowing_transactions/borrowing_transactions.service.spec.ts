import { Test, TestingModule } from '@nestjs/testing';
import { BorrowingTransactionsService } from './borrowing_transactions.service';

describe('BorrowingTransactionsService', () => {
  let service: BorrowingTransactionsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [BorrowingTransactionsService],
    }).compile();

    service = module.get<BorrowingTransactionsService>(BorrowingTransactionsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
