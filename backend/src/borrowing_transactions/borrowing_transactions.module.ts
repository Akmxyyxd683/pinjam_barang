import { Module } from '@nestjs/common';
import { BorrowingTransactionsService } from './borrowing_transactions.service';
import { BorrowingTransactionsController } from './borrowing_transactions.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BorrowingTransaction } from './entities/borrowing_transaction.entity';

@Module({
  imports: [TypeOrmModule.forFeature([BorrowingTransaction])],
  controllers: [BorrowingTransactionsController],
  providers: [BorrowingTransactionsService],
  exports: [BorrowingTransactionsService],
})
export class BorrowingTransactionsModule {}
