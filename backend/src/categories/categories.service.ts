import { Injectable, NotFoundException } from '@nestjs/common';
import { CategoryDto } from './dto/category.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Category } from './entities/category.entity';
import { Repository } from 'typeorm';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async create(CategoryDto: CategoryDto): Promise<Category> {
    const category = this.categoryRepository.create(CategoryDto);
    return this.categoryRepository.save(category);
  }

  async findAll(): Promise<Category[]> {
    return this.categoryRepository.find();
  }

  async findOne(id: number): Promise<Category | null> {
    const category = await this.categoryRepository.findOne({ where: { id } });
    if (!category) throw new NotFoundException('Category not found');
    return category;
  }

  async update(id: number, CategoryDto: CategoryDto): Promise<Category | null> {
    const category = await this.findOne(id);
    if (!category) {
      throw new NotFoundException('Category not found');
    }

    Object.assign(category, CategoryDto);

    return this.categoryRepository.save(category);
  }

  async remove(id: number): Promise<Boolean> {
    const category = await this.categoryRepository.findOne({ where: { id } });
    if (!category) return false;

    await this.categoryRepository.remove(category);
    return true;
  }
}
