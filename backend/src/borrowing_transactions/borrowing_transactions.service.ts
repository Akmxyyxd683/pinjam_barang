import { Injectable, NotFoundException } from '@nestjs/common';
import { BorrowingTransactionDto } from './dto/borrowing_transaction.dto';
import { BorrowingTransaction } from './entities/borrowing_transaction.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { promises } from 'dns';

@Injectable()
export class BorrowingTransactionsService {
  constructor(
    @InjectRepository(BorrowingTransaction)
    private readonly transactionRepository: Repository<BorrowingTransaction>,
  ) {}

  async create(
    BorrowingTransactionDto: BorrowingTransactionDto,
  ): Promise<BorrowingTransaction> {
    const transaction = this.transactionRepository.create(
      BorrowingTransactionDto,
    );
    return this.transactionRepository.save(transaction);
  }

  async findAll(): Promise<BorrowingTransaction[]> {
    return this.transactionRepository.find();
  }

  async findOne(id: number): Promise<BorrowingTransaction | null> {
    const transaction = await this.transactionRepository.findOne({
      where: { id },
    });
    if (!transaction) {
      throw new NotFoundException('History not found');
    }
    return transaction;
  }

  async update(
    id: number,
    BorrowingTransactionDto: BorrowingTransactionDto,
  ): Promise<BorrowingTransaction | null> {
    const updated = await this.transactionRepository.findOne({
      where: { id },
    });
    if (!updated) {
      throw new NotFoundException('History not found');
    }

    Object.assign(updated, BorrowingTransactionDto);

    return this.transactionRepository.save(updated);
  }

  async remove(id: number): Promise<boolean> {
    const deleted = await this.transactionRepository.findOne({ where: { id } });
    if (!deleted) {
      throw new NotFoundException('History not found');
    }

    await this.transactionRepository.remove(deleted);
    return true;
  }
}
