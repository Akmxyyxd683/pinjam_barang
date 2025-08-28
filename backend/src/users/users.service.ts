import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { LoginUserDto } from './dto/user.dto';
import * as bcrypt from 'bcrypt';
import { v2 as cloudinary } from 'cloudinary';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async create(loginUserDto: LoginUserDto): Promise<User> {
    const { email, name, password, profile_img, role, no_telp, alamat } =
      loginUserDto;

    let imageUrl: string | null = null;

    if (profile_img) {
      let toUpload = profile_img;

      const isDataUri = profile_img.startsWith('data:image');
      const isHttpUrl = /^https?:\/\//i.test(profile_img);
      if (!isDataUri && !isHttpUrl) {
        toUpload = `data:image/png;base64,${profile_img}`;
      }

      const result = await cloudinary.uploader.upload(toUpload, {
        folder: 'nestjs_items',
        resource_type: 'image',
      });

      imageUrl = result.secure_url;
    }

    // Check if user already exists
    const existingUser = await this.usersRepository.findOne({
      where: { email },
    });
    if (existingUser) {
      throw new ConflictException('Username already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const partial: DeepPartial<User> = {
      email,
      name,
      password: hashedPassword,
      profile_img: imageUrl,
      role,
      no_telp,
      alamat,
    };

    const user = this.usersRepository.create(partial);

    return this.usersRepository.save(user);
  }

  async login(loginUserDto: LoginUserDto): Promise<User> {
    const { email, password } = loginUserDto;

    // Find user
    const user = await this.usersRepository.findOne({ where: { email } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Compare password
    const isPasswordMatching = await bcrypt.compare(password, user.password);
    if (!isPasswordMatching) {
      throw new NotFoundException('Invalid credentials');
    }

    return user;
  }

  async findAll(): Promise<User[]> {
    return this.usersRepository.find({
      select: [
        'id',
        'email',
        'name',
        'profile_img',
        'role',
        'no_telp',
        'alamat',
      ],
    });
  }
}
